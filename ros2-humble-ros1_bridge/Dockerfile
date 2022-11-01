FROM ubuntu:jammy

LABEL app="ros2" \
      version="humble-ros1_bridge" \
      description="Imagem contendo os pacotes para integrar com o Warthog em ROS2" \
      maintainer="Erick Suzart Souza"

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    # Add the ROS 2 apt repository to the system
    apt install -y \
        curl \
        gnupg \
        lsb-release &&\
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg &&\
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null &&\
    # Install common packages
    apt update && \
    apt install -y --no-install-recommends \
        python3 \
        python3-pip \
        build-essential \
        cmake \
        git \
        python3-flake8 \
        python3-flake8-blind-except \
        python3-flake8-builtins \
        python3-flake8-class-newline \
        python3-flake8-comprehensions \
        python3-flake8-deprecated \
        python3-flake8-docstrings \
        python3-flake8-import-order \
        python3-flake8-quotes \
        python3-pip \
        python3-pytest \
        python3-pytest-cov \
        python3-pytest-repeat \
        python3-pytest-rerunfailures \
        python3-rosdep \
        python3-setuptools \
        wget \
        locales \
        tree \
        locate &&\
    # Install colcon and vcs
    python3 -m pip install -U colcon-common-extensions vcstool &&\
    # Clean up and remove the ROS 2 apt repository
    apt clean -y all

# Setup locale

RUN locale-gen en_US en_US.UTF-8 &&\
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8

# Create a workspace and clone all repos:
RUN mkdir -p /ros2_humble/src
WORKDIR /ros2_humble
RUN vcs import --input https://raw.githubusercontent.com/ros2/ros2/humble/ros2.repos src &&\
    # Install dependencies using rosdep
    rosdep init &&\
    rosdep update &&\
    apt update --fix-missing

RUN rosdep install --from-paths src --ignore-src -y --skip-keys "fastcdr rti-connext-dds-6.0.1 urdfdom_headers"

# Build the workspace
RUN colcon build --symlink-install

# Remove the ROS 2 apt repository and
# Install noetic required packages binaries
RUN rm /etc/apt/sources.list.d/ros2.list &&\
    apt update --fix-missing &&\
    apt install -y \
        ros-core-dev

# Setup the workspace with ros1_bridge
COPY src /workspace/src
WORKDIR /workspace

RUN source /ros2_humble/install/local_setup.bash &&\
    rosdep install --from-paths src --ignore-src -r -y --rosdistro humble &&\
    colcon build

ENV ROS1_DISTRO=noetic
ENV ROS2_DISTRO=humble
ENV AMENT_PREFIX_PATH="/ros2_humble/install:"
ENV COLCON_PREFIX_PATH="/ros2_humble/install:"
ENV CMAKE_PREFIX_PATH="/ros2_humble/install:"

COPY ros_entrypoint.sh /
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
