uv venv --python=3.13 xbot2gui-venv
source xbot2gui-venv/bin/activate
uv pip install 'git+https://github.com/ADVRHumanoids/robot_monitoring.git@proto_ros2#egg=xbot2-gui-server&subdirectory=server'
