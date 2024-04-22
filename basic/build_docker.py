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
        
    p = subprocess.run("timedatectl show | head -1 | sed 's/Timezone=//g'", capture_output=True, text=True, shell=True)
    host_timezone = p.stdout
    ubuntu_version = args["ubuntu_version"]
    base_image_type = args["base_type"]

    if base_image_type == "cudagl":
        base_image = f"cudagl:12.3.1-devel-ubuntu{ubuntu_version}"
    elif base_image_type == "cuda":
        base_image = f"cuda:12.3.1-devel-ubuntu{ubuntu_version}"
    elif base_image_type == "opengl":
        base_image = f"1.2-glvnd-devel-ubuntu{ubuntu_version}"

    print(f"Building with:\n"
          f" - Ubuntu version = {ubuntu_version}\n"
          f" - Base image type = {base_image_type}\n"
          f" - Base image = {base_image}\n"
          f" - Host timezone = {host_timezone}")
    name = "crizzard/lr-gym"
    out_image_name = f"{name}:{ubuntu_version.replace('.','')}-{base_image_type}-basic"
    print(f"Resulting image name: {out_image_name}")
    time.sleep(2)
    command =  (f'docker build --progress=plain'
                f' --tag {out_image_name}'
                f' --build-arg="TIMEZONE={host_timezone}"'
                f' --build-arg="UBUNTU_VERSION={ubuntu_version}" .')
    print(f"Running command: {command}")
    subprocess.run(command, shell = True)
