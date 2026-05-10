#  ROS2 Jazzy Kyon XBot2 Docker Image

This image contains ROS2 Jazzy, installed at /opt/ros/jazzy, plus XBot2, Mujoco Kyon and the necessary interfaces.
Binaries and configurations for XBot2, Xbot2_mujoco, XBot2_zmq, and kyon configuratios are installed in a forest-generated workspace at /opt/forest. Source files have been removed.

A helper for sourcing ROS and XBot-related tools is available at /setup_ros_xbot.sh

You can launch the container with:

```
utils/launch_persisting.sh crizzard/adarl:2404-ros-jazzy-xbot-mujoco adarl-jazzy-2404-xbot-mujoco --x11
```