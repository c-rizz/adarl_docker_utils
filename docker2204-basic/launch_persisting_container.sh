#!/bin/bash

container_name="lrgym-2204-basic"
docker container inspect $container_name > /dev/null 2>&1
if [ $? -ne 0 ]; then #if the previous command failed
    docker create --gpus all -it --shm-size=8gb \
         --net=host \
         --mount type=bind,source="$HOME",target=/home/host \
         --name $container_name \
         lr-gym:2204-basic \
         bash
fi

# Start an already-created container
docker start -i $container_name
