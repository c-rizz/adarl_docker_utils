uv venv --python=3.12 xbot2gui-venv
source xbot2gui-venv/bin/activate
uv pip install 'git+https://github.com/ADVRHumanoids/robot_monitoring.git@proto_ros2#egg=xbot2-gui-server&subdirectory=server'
mkdir xbot2gui-venv/lib/python3.12/site-packages/xbot2_gui_server/webui