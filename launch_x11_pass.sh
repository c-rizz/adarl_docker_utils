#!/bin/bash
XAUTH=/tmp/.docker.xauth

echo "Preparing Xauthority data..."
xauth_list=$(xauth nlist :0 | tail -n 1 | sed -e 's/^..../ffff/')
if [ ! -f $XAUTH ]; then
    if [ ! -z "$xauth_list" ]; then
        echo $xauth_list | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

echo "Done."
echo ""
echo "Verifying file contents:"
file $XAUTH
echo "--> It should say \"X11 Xauthority data\"."
echo ""
echo "Permissions:"
ls -FAlh $XAUTH
echo ""

docker create --gpus all -it  --shm-size=8gb --privileged \
         --env=NVIDIA_DRIVER_CAPABILITIES=all \
         --env="DISPLAY=$DISPLAY" \
         --env="QT_X11_NO_MITSHM=1"  \
         --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
         --env="XAUTHORITY=$XAUTH" \
         --volume="$XAUTH:$XAUTH" \
         --net=host \
         --mount type=bind,source="$HOME",target=/home/host \
         --name lr-gym-x11-pass \
         lr-gym:cuda11.1.1-noetic-desktop-full \
         /bin/bash

docker start -i lr-gym-x11-pass
