FROM osrf/ros:humble-desktop-full

SHELL ["/bin/bash", "-c"]

LABEL app="ros2" \
      version="cpr_warthog_ws" \
      description="Imagem contendo os pacotes para integrar com o Warthog em ROS2" \
      maintainer="Erick Suzart Souza"

ENV DEBIAN_FRONTEND=noninteractive

# install tools
RUN apt update && \
    sudo apt install -y --no-install-recommends \
        wget \
        python3-pip \
        locales \
        tree \
        locate \
        software-properties-common && \
    # clean up
    apt autoremove -y && \
    apt clean -y && \
    rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=dialog

COPY src /workspace/src

# Install dependencies and ros packages
RUN cd /workspace && \
    source /opt/ros/humble/setup.bash && \
    apt update && \
    # Install NAV2
    sudo apt install -y \
        ros-humble-navigation2 \
        ros-humble-nav2-bringup && \
    rosdep install --from-paths src --ignore-src -r -y

# Build the workspace
RUN cd /workspace && \
    source /opt/ros/humble/setup.bash && \
    colcon build

WORKDIR /workspace

ENTRYPOINT [ "/ros_entrypoint.sh" ]
CMD ["/bin/bash"]
