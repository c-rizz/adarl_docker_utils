#!/bin/bash

cd $(dirname $0)

image_name="crizzard/adarl:2404-ros-jazzy-xbot-mujoco"
container_name="adarl-jazzy-2404-xbot-mujoco"
../../utils/launch_persisting.sh $image_name $container_name $@
