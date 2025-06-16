ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND noninteractive


# -------------------- Install ROS Dependencies --------------------
ENV ROS_DISTRO noetic
RUN apt-get update && apt-get install --no-install-recommends -y \
    libgazebo11-dev \
    ros-$ROS_DISTRO-urdf ros-$ROS_DISTRO-kdl-parser \
    ros-$ROS_DISTRO-eigen-conversions ros-$ROS_DISTRO-robot-state-publisher ros-$ROS_DISTRO-moveit-core \
    ros-$ROS_DISTRO-rviz ros-$ROS_DISTRO-interactive-markers ros-$ROS_DISTRO-tf-conversions ros-$ROS_DISTRO-tf2-eigen \
    qttools5-dev libqt5charts5-dev qtdeclarative5-dev \
    libglfw3-dev \
    && rm -rf /var/lib/apt/lists/*

# -------------------- XBot --------------------

RUN sudo sh -c 'echo "deb http://xbot.cloud/xbot2/ubuntu/$(lsb_release -sc) /" > /etc/apt/sources.list.d/xbot-latest.list'
RUN wget -q -O - http://xbot.cloud/xbot2/ubuntu/KEY.gpg | sudo apt-key add -
RUN apt-get update && apt-get install --no-install-recommends -y xbot2_desktop_full \
    && rm -rf /var/lib/apt/lists/*
