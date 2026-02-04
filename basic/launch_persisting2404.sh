#!/bin/bash

cd $(dirname $0)

image_name="crizzard/adarl:2404-ubuntu-basic"
container_name="adarl-2404-ubuntu-basic"
../utils/launch_persisting.sh $image_name $container_name $@
