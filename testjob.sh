#!/bin/bash
#PBS -l select=1:ncpus=1:mpiprocs=1:ngpus=1
#PBS -l walltime=00:10:00
#PBS -j oe
#PBS -N test0
#PBS -q debug


echo "Job file..."
# module load cuda/11.1                          # Load the module my_module_name to set up the environment
# echo "Loaded cuda"
singularity exec --nv /work/$USER/lr_gym.sif /home/$USER/lr-gym-docker/testscript.sh
