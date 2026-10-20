#!/usr/bin/env bash
# expose_rootless_ports - manage RootlessKit port forwards for rootless Docker
#
# Usage:
#   expose_rootless_ports add <port>[-<end>] [tcp|udp] [bind-ip]   forward port(s) host -> rootless netns
#   expose_rootless_ports ls                                       list current forwards
#   expose_rootless_ports rm <id>|all                              remove a forward by id, or all of them
#
# Examples:
#   expose_rootless_ports add 5700              # tcp, all interfaces
#   expose_rootless_ports add 5700-5701 udp     # range, udp
#   expose_rootless_ports add 8080 tcp 127.0.0.1  # localhost only
#
# Note: forwards are lost when rootless dockerd restarts.

set -euo pipefail

SOCK="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/dockerd-rootless/api.sock"
API="http://rootlesskit/v1/ports"

die() { echo "expose_rootless_ports: $*" >&2; exit 1; }
[ -S "$SOCK" ] || die "socket not found at $SOCK (is rootless dockerd running?)"

rk() { curl -sS --unix-socket "$SOCK" "$@"; }

usage() { sed -n '2,15p' "$0" | sed 's/^# \{0,1\}//'; exit "${1:-0}"; }

cmd="${1:-}"; shift || true

case "$cmd" in
  add)
    [ $# -ge 1 ] || usage 1
    range="$1"; proto="${2:-tcp}"; ip="${3:-0.0.0.0}"
    [[ "$proto" == tcp || "$proto" == udp ]] || die "proto must be tcp or udp"
    if [[ "$range" =~ ^([0-9]+)-([0-9]+)$ ]]; then
      start="${BASH_REMATCH[1]}"; end="${BASH_REMATCH[2]}"
    elif [[ "$range" =~ ^[0-9]+$ ]]; then
      start="$range"; end="$range"
    else
      die "invalid port: $range"
    fi
    (( start >= 1 && end <= 65535 && start <= end )) || die "port out of range: $range"
    for ((p = start; p <= end; p++)); do
      out=$(rk -X POST "$API" -H 'Content-Type: application/json' \
        -d "{\"proto\":\"$proto\",\"parentIP\":\"$ip\",\"parentPort\":$p,\"childPort\":$p}")
      echo "$p/$proto -> $out"
    done
    ;;
  ls|list)
    out=$(rk "$API")
    if command -v jq >/dev/null; then
      echo "$out" | jq -r '(["ID","PROTO","BIND","HOST","CHILD"] | @tsv),
        (.[] | [.id, .spec.proto, .spec.parentIP, .spec.parentPort, .spec.childPort] | @tsv)' \
        | column -t
    else
      echo "$out"
    fi
    ;;
  rm|del)
    [ $# -ge 1 ] || usage 1
    if [ "$1" = all ]; then
      ids=$(rk "$API" | grep -o '"id":[0-9]*' | cut -d: -f2)
      [ -n "$ids" ] || { echo "no forwards"; exit 0; }
      for id in $ids; do rk -X DELETE "$API/$id" && echo "removed $id"; done
    else
      rk -X DELETE "$API/$1" && echo "removed $1"
    fi
    ;;
  -h|--help|help|"") usage 0 ;;
  *) usage 1 ;;
esac