# Docker Images and Utils for lr_gym

### Getting singularity
To build the isngularity image you will need singularity on your system.
To get a recent version you will need to install from source. You can follow the instructions at https://sylabs.io/guides/3.6/user-guide/quick_start.html#quick-installation-steps

## Build images
To get the singularity image you will need to:
 * Build the docker image
 * Build the sandbox singularity folder from the docker image
 * Build the singularity image from the sandbox

All of this steps are not really necessary, you could directly do the singularity image or skip the sandbox, but this is how I did it (mostly to play around with it)


## Using the images locally
You can use the various launch_* script to aunch the docker or the singularity in your local system

## Using the singularity images on HPC (IIT Franklin)
You will need to copy the singularity sif image to the HPC (On Franklin I suggest the your work folder in /work/<username>)
The you can submit a job that runs sigularity from inside a compute node.
For example you can try the testjob.sh job script as follows:

```
qsub -o /home/<username>/joubouts/ testjob.sh
```

This will put in the queue the job and place its output in ~/jobouts.
The job will execute singularity inside the docker and run the testscript.sh script in it.

You can also run an interactive sell in the node with for example:

```
qsub -I testjob.sh
```

You can chek the state of you jobs in the quque with ./checkMyQueue.sh, the S column tells you if it is in queue (Q), running, (R), or in other states.

Once the testjob.sh job is finished the last lines of the output should say "Cuda available = True" and the model of the gpu
