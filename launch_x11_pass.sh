#!/bin/bash
XAUTH=/tmp/.lr-gym-docker.xauth

if [ -z ${DISPLAY+x} ]; then
    echo '$DISPLAY is not set, please set it to the correct X11 display. (Probably it is ":0" or ":1")'
    exit 1
fi

#echo "Preparing Xauthority data..."
xauth_list=$(xauth nlist $DISPLAY | tail -n 1 | sed -e 's/^..../ffff/')
if [ ! -z "$xauth_list" ]; then
    echo $xauth_list | xauth -f $XAUTH nmerge -
else
    touch $XAUTH
fi
chmod a+r $XAUTH


#echo "Done."
#echo ""
#echo "Verifying file contents:"
#file $XAUTH
#echo "--> It should say \"X11 Xauthority data\"."
#echo ""
#echo "Permissions:"
#ls -FAlh $XAUTH
#echo ""


container_name=lr-gym-x11-pass
docker container inspect $container_name > /dev/null 2>&1

if [ $? -ne 0 ]; then
    docker create --gpus all -it  --shm-size=8gb --privileged \
         --env=NVIDIA_DRIVER_CAPABILITIES=all \
         --env="DISPLAY=$DISPLAY" \
         --env="QT_X11_NO_MITSHM=1"  \
         --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
         --env="XAUTHORITY=$XAUTH" \
         --volume="$XAUTH:$XAUTH" \
         --net=host \
         --mount type=bind,source="$HOME",target=/home/host \
         --name $container_name \
         lr-gym:cuda11.1.1-noetic-desktop-full \
         /bin/bash
fi

xhost +local: 
docker start -i $container_name