#!/usr/bin/env python3

import subprocess
import argparse
import time

if __name__=="__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--ubuntu-version", default="22.04", type=str, help="Ubuntu version to use")
    ap.add_argument("--base-type", default="opengl", type=str, help="Base image to use (cudagl, cuda, opengl)")
    ap.set_defaults(feature=True)
    args = vars(ap.parse_args())
    print(args)
    if args["base_type"] not in ["cudagl","cuda","opengl","ubuntu","ros-humble", "ros-jazzy"]:
        raise NotImplementedError(f"Unsupported base type {args['base_type']}")
    if args["ubuntu_version"] not in ["20.04","22.04","24.04"]:
        raise NotImplementedError(f"Unsupported ubuntu version {args['ubuntu_version']}")
        
    p = subprocess.run("timedatectl show | head -1 | sed 's/Timezone=//g'", capture_output=True, text=True, shell=True)
    host_timezone = p.stdout.strip()
    ubuntu_version = args["ubuntu_version"]
    base_image_type = args["base_type"]

    ubuntu_version2name = {"20.04": "focal", "22.04": "jammy", "24.04": "noble"}

    types_to_base_image = { "cudagl" : f"nvidia/cudagl:12.3.1-devel-ubuntu{ubuntu_version}",
                            "cuda": f"nvidia/cuda:12.3.1-devel-ubuntu{ubuntu_version}",
                            "opengl": f"nvidia/opengl:1.2-glvnd-devel-ubuntu{ubuntu_version}",
                            "ubuntu": f"library/ubuntu:{ubuntu_version}",
                            "ros-humble": f"ros:humble-ros-base-{ubuntu_version2name[ubuntu_version]}",
                            "ros-jazzy": f"ros:jazzy-ros-base-{ubuntu_version2name[ubuntu_version]}"
                            }
    base_image = types_to_base_image.get(base_image_type, None)
    if base_image is None:
        raise NotImplementedError(f"Unsupported base type {base_image_type}. available types are {list(types_to_base_image.keys())}")
        

    print(f"Building with:\n"
          f" - Ubuntu version = {ubuntu_version}\n"
          f" - Base image type = {base_image_type}\n"
          f" - Base image = {base_image}\n"
          f" - Host timezone = {host_timezone}")
    name = "crizzard/adarl"
    out_image_name = f"{name}:{ubuntu_version.replace('.','')}-{base_image_type}-basic"
    print(f"Resulting image name: {out_image_name}")
    time.sleep(2)
    command =  (f'docker build --progress=plain'
                f' --tag {out_image_name}'
                f' --build-arg="TIMEZONE={host_timezone}"'
                f' --build-arg="BASE_IMAGE={base_image}" ./basic')
    print(f"Running command: {command}")
    subprocess.run(command, shell = True)
