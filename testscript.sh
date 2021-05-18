#!/bin/bash
echo "Test script..."
nvidia-smi
cd /home/crizzardo/catkin-ws
. ./virtualenv/lr_gym_sb3/bin/activate
python3 -c "exec(\"import torch\nprint('Cuda available =',torch.cuda.is_available())\nprint(torch.cuda.get_device_name())\")"
