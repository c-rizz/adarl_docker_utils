#!/bin/bash

cd $(dirname $0)

image_name="crizzard/lr-gym:2204-cudagl-basic"
container_name="lr-gym-2204-cudagl-basic"
../utils/launch_persisting.sh $image_name $container_name
