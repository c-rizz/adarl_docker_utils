#!/bin/bash

# Starts up a container, if the container with the provided name exists already 
# it uses it, if it does not exist it creates a new one

if [ $# -lt 2 ] || [ $# -gt 3  ] ; then
    echo ""
    echo "Starts up a container, if the container with the provided name exists already"
    echo "it uses it, if it does not exist it creates a new one."
    echo ""
    echo "Usage is:"
    echo "    launch_persisting.sh <image_name> <container_name> [--rootless]"
    echo " e.g.:"
    echo "    launch_persisting.sh crizzard/lr-gym 2204-cudagl-basic --rootless"
    echo ""
    exit 0
fi

image_name=$1
container_name=$2

# if --rootless is among the arguments
if [[ "$*" == *"--rootless"* ]] ; then
    rootless=true
else
    rootless=false
fi

extra_create_args=""
# if --x11 is among the arguments
if [[ "$*" == *"--x11"* ]] ; then
    # get the xauth entries for display $DISPLAY
    # get the first entry
    # remove the "/unix" part of the hostname
    xauth_entry=$(xauth list $DISPLAY | head -n 1 | sed "s/\/unix//g")
    echo "Got xauth entry: $xauth_entry"
fi

if $rootless ; then
    # In rootless mode we cannot use --net host, so at least we just expose one port
    if [ $? -ne 0 ]; then #if the previous command failed
        echo "Creating container for rootless mode"
        docker create --gpus all -it \
             --p 9422:9422 \
             --mount type=bind,source="$HOME",target=/home/host \
             --name $container_name \
             --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
             $image_name \
             bash
    fi
else
    docker container inspect $container_name > /dev/null 2>&1
    if [ $? -ne 0 ]; then #if the previous command failed
        echo "Creating container for non-rootless mode"
        docker create --gpus all -it \
             --net=host \
             --mount type=bind,source="$HOME",target=/home/host \
             --name $container_name \
             --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
             $image_name \
             bash
    fi
fi

# Start an already-created container
docker start -i $container_name
