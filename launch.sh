#!/bin/bash

docker create --gpus all --mount type=bind,source="$HOME",target=/home/host -it --name lr-gym nvidia-ros:cuda11.1.1-noetic-desktop-full /bin/bash
docker start -i lr-gym
