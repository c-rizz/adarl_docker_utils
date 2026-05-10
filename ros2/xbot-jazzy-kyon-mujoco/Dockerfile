ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir -p -m 0600 /root/.ssh
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts
# RUN chmod 0600 /root/.ssh/config

RUN apt-get update && apt-get install -y \
                    libboost-all-dev libhdf5-dev libqhull-dev libassimp-dev liboctomap-dev \
                    ros-jazzy-srdfdom ros-jazzy-geometric-shapes ros-jazzy-gz-cmake-vendor \
                    libglfw3-dev ros-jazzy-xacro libprotobuf32t64 ros-jazzy-rmw-cyclonedds-cpp  \
    && rm -rf /var/lib/apt/lists/*

COPY install_workspace_ros2xbot.sh /tmp/install_workspace_ros2xbot.sh
RUN --mount=type=ssh \
        mkdir -p /opt/forest && \
        cd /opt/forest && \
        /tmp/install_workspace_ros2xbot.sh && \
        rm /tmp/install_workspace_ros2xbot.sh && \
        rm -rf /opt/forest/forest_ws/src /opt/forest/forest_ws/ros_src /opt/forest/forest_ws/build /opt/forest/forest_ws/recipes
COPY setup_ros_xbot.sh /setup_ros_xbot.sh