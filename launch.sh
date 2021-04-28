#!/bin/bash

container_name=lr-gym
docker container inspect $container_name > /dev/null 2>&1

if [ $? -ne 0 ]; then
    docker create --gpus all \
                  --mount type=bind,source="$HOME",target=/home/host \
                  -it \
                  --name $container_name \
                  lr-gym:cuda11.1.1-noetic-desktop-full /bin/bash
fi
docker start -i $container_name
