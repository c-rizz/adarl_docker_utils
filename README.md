# Docker Images and Utils for lr_gym

# Docker

A collection of docker images is provided:
* *basic* images provide a base set of useful packages on top of cuda/cudagl/opengl base images
* *ros1* images provide a basic ros installation on top of *basic* images
* *ros1-xbot* images provide a xbot installation and simulation tools (gazebo) on top of the *ros1* images

All these images can be build uisng the build_docker scripts in the respective folders.

The launch_persisting.sh script in utils/ can be used to launch the images with appropriate settings.
All images are launched while mounting the host's home folder in /host/home, making it easy to access 
files in the host's filesystem.

The launch_persisting script also provides options to allow the use of gui applications within the docker (--x11)
and to correctly launch for a docker rootless installation (--rootless).

# Singularity (This section may be out of date)

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
