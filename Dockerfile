FROM osrf/ros:noetic-desktop-full

SHELL ["/bin/bash", "-c"]

LABEL app="ros1" \
      version="cpr_warthog_ws" \
      description="Imagem contendo os pacotes referentes ao Warthog" \
      maintainer="Erick Suzart Souza"

# ENV DEBIAN_FRONTEND=noninteractive
# RUN apt-get update \
#    && apt-get -y install --no-install-recommends <your-package-list-here> \
#    #
#    # Clean up
#    && apt-get autoremove -y \
#    && apt-get clean -y \
#    && rm -rf /var/lib/apt/lists/*
# ENV DEBIAN_FRONTEND=dialog


ENV DEBIAN_FRONTEND=noninteractive

# install tools
RUN apt update && \
    sudo apt install -y --no-install-recommends \
        wget \
        git \
        python3-pip \
        locales \
        tree \
        locate \
        software-properties-common && \
    sudo pip3 install -U catkin_tools && \
    # clean up
    apt autoremove -y && \
    apt clean -y && \
    rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=dialog

# Modify the gazebo kill timeout
RUN sed -i 's/DEFAULT_TIMEOUT_SIGTERM = 2.0 #seconds/DEFAULT_TIMEOUT_SIGTERM = 1.0 #seconds/g' /opt/ros/$ROS_DISTRO/lib/python3/dist-packages/roslaunch/nodeprocess.py && \
    sed -i 's/DEFAULT_TIMEOUT_SIGINT  = 15.0 #seconds/DEFAULT_TIMEOUT_SIGINT  = 1.0 #seconds/g' /opt/ros/$ROS_DISTRO/lib/python3/dist-packages/roslaunch/nodeprocess.py

COPY src /workspace/src

RUN mkdir -p /workspace/src && \
    cd /workspace/src && \
    source /opt/ros/noetic/setup.bash && \
    cd /workspace && \
    catkin build

WORKDIR /workspace

ENTRYPOINT [ "/ros_entrypoint.sh" ]
CMD ["/bin/bash"]