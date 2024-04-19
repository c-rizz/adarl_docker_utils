#!/bin/bash

container_name="lr-gym-2204-cudagl-basic"
docker container inspect $container_name > /dev/null 2>&1
if [ $? -ne 0 ]; then #if the previous command failed
    docker create --gpus all -it \
         --mount type=bind,source="$HOME",target=/home/host \
         --name $container_name \
         -p 9422:9422 \
         crizzard/lr-gym:2204-cudagl-basic \
         bash
fi

# Start an already-created container
docker start -i $container_name
