#!/bin/bash
set -e

# Source ROS and Colcon workspaces.
source /opt/ros/humble/install/local_setup.bash
echo "Sourced ROS humble workspace."

# Source the workspace.
if [ -f /workspace/install/setup.bash ]
then
  source /workspace/install/setup.bash
  echo "Sourced code workspace"
fi

exec "$@"