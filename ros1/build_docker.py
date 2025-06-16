#!/usr/bin/env python3

import subprocess
import argparse
import time

if __name__=="__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--ubuntu-version", default="22.04", type=str, help="Ubuntu version to use")
    ap.add_argument("--base-type", default="cudagl", type=str, help="Base image to use (cudagl, cuda, opengl)")
    ap.set_defaults(feature=True)
    args = vars(ap.parse_args())
    print(args)
    if args["base_type"] not in ["cudagl","cuda","opengl"]:
        raise NotImplementedError(f"Unsupported base type {args['base_type']}")
    if args["ubuntu_version"] not in ["20.04","22.04"]:
        raise NotImplementedError(f"Unsupported ubuntu version {args['ubuntu_version']}")
        
    ubuntu_version = args["ubuntu_version"]
    base_image_type = args["base_type"]

    if base_image_type == "cudagl":
        base_image = f"crizzard/adarl:{ubuntu_version.replace('.','')}-cudagl-basic"
    elif base_image_type == "cuda":
        base_image = f"crizzard/adarl:{ubuntu_version.replace('.','')}-cuda-basic"
    elif base_image_type == "opengl":
        base_image = f"crizzard/adarl:{ubuntu_version.replace('.','')}-opengl-basic"


    print(f"Building with:\n"
          f" - Ubuntu version = {ubuntu_version}\n"
          f" - Base image type = {base_image_type}\n"
          f" - Base image = {base_image}\n")
    name = "crizzard/adarl"
    out_image_name = f"{name}:ros1-{ubuntu_version.replace('.','')}-{base_image_type}"
    print(f"Resulting image name: {out_image_name}")
    time.sleep(2)
    command =  (f' docker build --progress=plain'
                f' --tag {out_image_name}'
                f' --build-arg="BASE_IMAGE={base_image}" ./ros1')
    print(f"Running command: {command}")
    subprocess.run(command, shell = True)
