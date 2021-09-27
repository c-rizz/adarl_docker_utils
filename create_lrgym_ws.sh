#!/bin/bash

cd /home/host
mkdir catkin-ws-autorl
cd catkin-ws-autorl
mkdir src
catkin build
cd src
git clone --branch noetic-sb3 https://gitlab.idiap.ch/learn-real/lr_gym.git
git clone --branch crzz-dev https://gitlab.idiap.ch/learn-real/panda.git lr_panda
git clone --branch crzz-dev https://gitlab.idiap.ch/learn-real/lr_panda_moveit_config.git lr_panda_moveit_config
git clone --branch crzz-dev https://gitlab.idiap.ch/learn-real/realsense.git lr_realsense
cd ..
sudo apt update
rosdep install --from-paths src --ignore-src -r -y
catkin build -DCMAKE_BUILD_TYPE=Release
./src/lr_gym/lr_gym/build_virtualenv.sh sb3



