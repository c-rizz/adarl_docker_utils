#! /usr/bin/env python3
import time
import subprocess

name = "crizzard/adarl"
ubuntu_version = "24.04"
base_image_type = "ros-jazzy"
base_image = "ros:jazzy-ros-base"

base_image_name = f"{name}:{ubuntu_version.replace('.','')}-{base_image_type}-basic"

out_image_name = f"{name}:{ubuntu_version.replace('.','')}-{base_image_type}-xbot-mujoco"
print(f"Resulting image name: {out_image_name}")
time.sleep(2)
command =  (f'docker build --progress=plain'
            f' --tag {out_image_name}'
            f' --build-arg="BASE_IMAGE={base_image_name}" '
            f' --ssh=default'
            f' ./ros2/xbot-jazzy-kyon-mujoco')
print(f"Running command: {command}")
subprocess.run(command, shell = True)