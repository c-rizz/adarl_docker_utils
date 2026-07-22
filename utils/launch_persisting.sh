#!/bin/bash

# Starts up a container, if the container with the provided name exists already
# it uses it, if it does not exist it creates a new one

if [ $# -lt 2 ] ; then
    echo ""
    echo "Starts up a container, if the container with the provided name exists already"
    echo "it uses it, if it does not exist it creates a new one."
    echo ""
    echo "Usage is:"
    echo "    launch_persisting.sh <image_name> <container_name> [--rootless] [--x11] [--ports p1,p2,...]"
    echo " e.g.:"
    echo "    launch_persisting.sh crizzard/lr-gym 2204-cudagl-basic --rootless --ports 9422"
    echo ""
    exit 0
fi

image_name=$1
container_name=$2

# Ports published in rootless mode. Override with e.g. --ports 9422,49100,47998
# (comma- or space-separated). Scanned from a copy of the args so the substring
# flag checks below (which look at "$*") keep working.
ports="9422"
all_args=("$@")
for ((i=0; i<${#all_args[@]}; i++)); do
    if [ "${all_args[i]}" = "--ports" ] ; then
        ports="${all_args[i+1]//,/ }"
    fi
done

if [[ "$*" == *"--rootless"* ]] ; then
    rootless=true
elif [[ "$*" == *"--no-rootless"* ]] ; then
    rootless=false
else
    if [ $(docker context show) = "rootless" ] ; then
        rootless=true
    else
        rootless=false
    fi
fi

if [[ "$XDG_SESSION_TYPE" == *"tty"* ]] ; then
# assume wayland
    XDG_SESSION_TYPE="wayland"
fi

docker container inspect $container_name > /dev/null 2>&1
if [ $? -ne 0 ]; then #if the previous command failed, which means the container doe not exist yet

    create_args="--gpus all -it --mount type=bind,source=$HOME,target=/home/host --hostname ${container_name} "
    # if --rootless is among the arguments

    if [ "$rootless" = true ] ; then
        echo "Creating container for rootless mode, will reserve ports: $ports"
        for p in $ports ; do
            create_args="$create_args --publish $p"
        done
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
        # To let x11 use shared memory (breaks isolation)
        create_args="$create_args --ipc=host"
        # make all programs use nvidia for glx
        create_args="$create_args --env=__NV_PRIME_RENDER_OFFLOAD=1 --env=__GLX_VENDOR_LIBRARY_NAME=nvidia"
        if [[ "$XDG_SESSION_TYPE" == *"wayland"* ]] ; then
            create_args="$create_args --env=XDG_RUNTIME_DIR=/tmp"
            create_args="$create_args --env=WAYLAND_DISPLAY=$WAYLAND_DISPLAY"
            create_args="$create_args -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:/tmp/$WAYLAND_DISPLAY"
        fi
    fi
    # NVIDIA_DRIVER_CAPABILITIES=all allows gazebo to use the nvidia gpu for rendering
    create_args="$create_args --env=NVIDIA_DRIVER_CAPABILITIES=all --shm-size=512m --entrypoint /bin/bash "
    create_args="$create_args --env=HOSTHOSTNAME=$HOSTNAME "
    create_args="$create_args --group-add $(getent group render | cut -d: -f3)" # add the user's primary group to the container
    create_args="$create_args --group-add $(getent group video | cut -d: -f3)"  # add the video group to the container to allow gpu access
    create_args="$create_args --device /dev/dri:/dev/dri"               # give access to dri devices for gpu acceleration
    create_args="$create_args --name $container_name $image_name"
    # To allow usage of secondary GPUs for rendering
    echo ""
    echo "creating container with args:"
    echo " $create_args"
    docker create $create_args
fi

echo "Current session type: $XDG_SESSION_TYPE"
for p in $ports ; do
    echo "Exposing port $p as $(docker port $container_name $p/tcp | awk -F: '{print $2}')"
done

xhost +local:
# Start an already-created container
if [[ "$*" == *"--no-start"* ]] ; then
    echo "$container_name"
else
    docker start -i $container_name
fi
