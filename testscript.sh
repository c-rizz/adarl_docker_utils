#!/bin/bash
nvidia-smi
./virtualenv/lr_gym_sb3/bin/activate
python3 -c "exec(\"import torch\nprint(torch.cuda.is_available())\nprint(torch.cuda.get_device_name())\")"
