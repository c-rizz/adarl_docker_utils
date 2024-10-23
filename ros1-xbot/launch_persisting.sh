#!/bin/bash

cd $(dirname $0)

image_name="crizzard/ros-xbot:2004-opengl"
container_name="xbot-2004-test"
../utils/launch_persisting.sh $image_name $container_name --x11