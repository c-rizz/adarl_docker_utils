#!/bin/bash

if [ -z ${1+x} ]; then
	echo "syntax is: get_lr_gym.sh <dest_folder>"
	exit 0
fi


git clone  --branch master https://gitlab-docker-deploy-token:Bp6Kfk-8GUyKwypvimhV@gitlab.idiap.ch/learn-real/lr_gym.git $1/src/lr_gym
git clone  --branch crzz-dev https://gitlab-docker-deploy-token:Usm5fNeN7XoDXoUhtuuE@gitlab.idiap.ch/learn-real/panda.git $1/src/lr_panda
git clone  --branch crzz-dev https://gitlab-docker-deploy-token:u_zz_gry5BCgS1sakF2Q@gitlab.idiap.ch/learn-real/lr_panda_moveit_config.git $1/src/lr_panda_moveit_config
git clone  --branch crzz-dev https://gitlab-docker-deploy-token:PpsDwupbSkZyPxXFC2x7@gitlab.idiap.ch/learn-real/realsense.git $1/src/lr_realsense
