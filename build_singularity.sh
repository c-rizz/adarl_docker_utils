#!/bin/bash

echo "This may take a looooong time (hours)"
sudo singularity build --sandbox build/lr_gym_sandbox/ lr_gym.def
