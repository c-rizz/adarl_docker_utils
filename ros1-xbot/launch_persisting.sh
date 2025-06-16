#!/bin/bash

cd $(dirname $0)

image_name="crizzard/adarl:ros1-xbot-2004-opengl"
container_name="adarl-xbot-2004"
../utils/launch_persisting.sh $image_name $container_name --x11 $@