#!/bin/bash
#PBS -l select=1:ncpus=4:mpiprocs=1:ngpus=1    # Request 1 chunk of 4 cores 1 gpu
#PBS -l walltime=00:10:00                      # Request 10 minutes runtime
#PBS -j oe                                     # Merge the error and output streams into a single file
#PBS -N torch_test                             # Specify the job name
#PBS -q gpu                                    # Use the gpu nodes

cd $WORKDIR
module load cuda/11.1                          # Load the module my_module_name to set up the environment
singularity exec lr-gym.img ./test_script

