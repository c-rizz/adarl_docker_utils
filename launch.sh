#!/bin/bash

docker create --gpus all -it --name nvidia-ros-1 nvidia-ros:cuda11.1.1-noetic-desktop-full /bin/bash
docker start -i nvidia-ros-1
