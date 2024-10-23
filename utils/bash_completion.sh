#!/bin/bash

apt install bash-completion
sed -i 's/^/#/' /etc/apt/apt.conf.d/docker-clean 

echo "
# enable bash completion in interactive shells
#if ! shopt -oq posix; then
#  if [ -f /usr/share/bash-completion/bash_completion ]; then
#    . /usr/share/bash-completion/bash_completion
#  elif [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#  fi
#fi
" >> $HOME/.bashrc