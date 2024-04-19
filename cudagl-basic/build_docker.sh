#!/bin/bash
cd "$(dirname "$0")"
ubuntu_version=$1
if [ -z "$ubuntu_version" ] ; then
    ubuntu_version="22.04"
fi
host_timezone=$(timedatectl show | head -1 | sed 's/Timezone=//g')
echo "Building with Ubuntu version = $ubuntu_version"
tag=$(echo "$ubuntu_version-cudagl-basic" | sed 's/\.//g')
name="crizzard/lr-gym"
echo "Building image as $name:$tag"
sleep 2
docker build --tag $name:$tag --build-arg="TIMEZONE=$host_timezone" --build-arg="UBUNTU_VERSION=$ubuntu_version" .
