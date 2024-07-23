#!/bin/bash

# Starts up a container, if the container with the provided name exists already 
# it uses it, if it does not exist it creates a new one

if [ $# -lt 2 ] || [ $# -gt 4  ] ; then
    echo ""
    echo "Starts up a container, if the container with the provided name exists already"
    echo "it uses it, if it does not exist it creates a new one."
    echo ""
    echo "Usage is:"
    echo "    launch_persisting.sh <image_name> <container_name> [--rootless] [--x11]"
    echo " e.g.:"
    echo "    launch_persisting.sh crizzard/lr-gym 2204-cudagl-basic --rootless"
    echo ""
    exit 0
fi

image_name=$1
container_name=$2


docker container inspect $container_name > /dev/null 2>&1
if [ $? -ne 0 ]; then #if the previous command failed, which means the container doe not exist yet

    create_args="--gpus all -it --mount type=bind,source=$HOME,target=/home/host "
    # if --rootless is among the arguments
    if [[ "$*" == *"--rootless"* ]] ; then
        echo "Creating container for rootless mode"
        create_args="$create_args --publish 9422:9422"
    else
        echo "Creating container for non-rootless mode"
        create_args="$create_args --net=host"
    fi

    # if --x11 is among the arguments
    if [[ "$*" == *"--x11"* ]] ; then
        # get the xauth entries for display $DISPLAY
        # get the first entry
        # remove the "/unix" part of the hostname
        xauth_entry=$(xauth list $DISPLAY | head -n 1 | sed "s/\/unix//g")
        echo "Got xauth entry: $xauth_entry"
        create_args="$create_args --volume=/tmp/.X11-unix:/tmp/.X11-unix:rw"
        create_args="$create_args --env=DISPLAY=$DISPLAY"
    fi
    # NVIDIA_DRIVER_CAPABILITIES=all allows gazebo to use the nvidia gpu for rendering
    create_args="$create_args --env=NVIDIA_DRIVER_CAPABILITIES=all"

    create_args="$create_args --name $container_name $image_name bash" 
    echo "creating container with args: $create_args"
    docker create $create_args
fi

# Start an already-created container
docker start -i $container_name
