# Docker Images and Utils for lr_gym

# Docker

You can build the docker image using the build_docker.sh script.

Once you have done that you can launch the container with launch.sh.

If you need rendering you may want to pass through access your host X11 server, you can do so by using launch_x11_pass.sh.

**The launch scripts will mount your entire home folder in /home/host/ and use user root.**
You can at this point proceed to create a catkin workspace and clone lr_gym and dependencies in it.

For example:
```
cd /home/host
mkdir catkin-ws
cd catkin-ws
mkdir src
catkin build
cd src
git clone --branch noetic-sb3 https://gitlab.idiap.ch/learn-real/lr_gym.git
git clone --branch crzz-dev https://gitlab.idiap.ch/learn-real/panda.git lr_panda
git clone --branch crzz-dev https://gitlab.idiap.ch/learn-real/lr_panda_moveit_config.git lr_panda_moveit_config
git clone --branch crzz-dev https://gitlab.idiap.ch/learn-real/realsense.git lr_realsense
cd ..
catkin build -DCMAKE_BUILD_TYPE=Release
./src/lr_gym/lr_gym/build_virtualenv.sh sb3
```

At this point this should work:
```
cd /home/host/catkin-ws
. virtualenv/lr_gym_sb3/bin/activate
. devel/setup.bash
rosrun lr_gym test_cartpole_env.py --xvfb --render
```

# Singularity

### Getting singularity
To build the singularity image you will need singularity on your system.
To get a recent version you will need to install from source. You can follow the instructions at https://sylabs.io/guides/3.6/user-guide/quick_start.html#quick-installation-steps

## Build images
To get the singularity image you will need to:

 * Build the docker image
 * Build the sandbox singularity folder from the docker image
 * Build the singularity image from the sandbox

All of this steps are not really necessary, you could directly define a singularity image or skip the sandbox, but this is how I did it.


## Using the images locally
You can use the various launch_* script to aunch the docker or the singularity in your local system

## Using the singularity images on IIT Franklin
You will need to copy the singularity sif image to the HPC (On Franklin I suggest your work folder in /work/<username>)
The you can submit a job that runs sigularity from inside a compute node.
For example you can try the testjob.sh job script as follows:

```
qsub -o /home/<username>/joubouts/ testjob.sh
```

This will put in the queue the job and place its output in ~/jobouts.
The job will execute singularity inside the node and run the testscript.sh script in it.

You can also run an interactive sell in the node with for example:

```
qsub -I testjob.sh
```

You can chek the state of you jobs in the queue with ./checkMyQueue.sh, the S column tells you if it is in queue (Q), running, (R), or in other states.

Once the testjob.sh job is finished the last lines of the output should say "Cuda available = True" and the model of the gpu
