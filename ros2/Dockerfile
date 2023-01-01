FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y \
	python3-opencv ca-certificates python3-dev git wget sudo vim iputils-ping ssh \
	dirmngr gnupg2 \
	build-essential \
	byobu \
	python3-yaml \
	apt-utils \
	software-properties-common \
	curl
    # python-rosdep \
    # python-rosinstall \
    # python-vcstools \
# RUN ln -sv /usr/bin/python3 /usr/bin/python


# ----------------------------------------------------------------------
# System setup
# ----------------------------------------------------------------------

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

USER root

RUN wget https://bootstrap.pypa.io/get-pip.py && \
	python3 get-pip.py --user && \
	rm get-pip.py
ENV PATH $PATH:/root/.local/bin

#Byobu Fix for launching BASH instead of SH
RUN mkdir -p /root/.byobu/
RUN echo 'set -g default-shell /bin/bash' >>/root/.byobu/.tmux.conf
RUN echo 'set -g default-command /bin/bash' >>/root/.byobu/.tmux.conf

# create a non-root user
ARG USER_ID=1000
ARG USER_NAME=user1000
RUN useradd -m --no-log-init --system  --uid ${USER_ID} ${USER_NAME} -g sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}

ENV PATH="/home/${USER_NAME}/.local/bin:${PATH}"
# ----------------------------------------------------------------------




# ----------------------------------------------------------------------
# Install ROS
# ----------------------------------------------------------------------
USER root

RUN bash -c 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null'
RUN wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg

RUN apt-get update && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN bash -c 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null'
RUN apt-get update && apt-get install -y ros-humble-desktop
RUN apt-get update && apt-get install -y python3-colcon-common-extensions
RUN apt-get update && apt-get install -y python3-rosdep
RUN rosdep init
USER ${USER_NAME}
RUN rosdep update

# ----------------------------------------------------------------------



