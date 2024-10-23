#!/bin/bash

sudo apt update
sudo apt install bash-completion

cat <<EOT >> ~/.bashrc
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
EOT

rm /etc/apt/apt.conf.d/docker-clean
