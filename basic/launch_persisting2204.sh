#!/bin/bash

cd $(dirname $0)

image_name="crizzard/adarl:2204-opengl-basic"
container_name="adarl-2204-opengl-basic"
../utils/launch_persisting.sh $image_name $container_name $@
