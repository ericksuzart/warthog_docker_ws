FROM osrf/ros:humble-desktop-full

SHELL ["/bin/bash", "-c"]

LABEL app="ros1" \
      version="cpr_warthog_ws" \
      description="Imagem contendo os pacotes referentes ao Warthog" \
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

# Modify the gazebo kill timeout
# RUN sed -i 's/DEFAULT_TIMEOUT_SIGTERM = 2.0 #seconds/DEFAULT_TIMEOUT_SIGTERM = 1.0 #seconds/g' /opt/ros/humble/lib/python3/dist-packages/roslaunch/nodeprocess.py && \
#     sed -i 's/DEFAULT_TIMEOUT_SIGINT  = 15.0 #seconds/DEFAULT_TIMEOUT_SIGINT  = 1.0 #seconds/g' /opt/ros/humble/lib/python3/dist-packages/roslaunch/nodeprocess.py

COPY src /workspace/src

# Install dependencies
RUN cd /workspace && \
    source /opt/ros/humble/setup.bash && \
    apt update && \
    rosdep install --from-paths src --ignore-src -r -y

# Build the workspace
RUN cd /workspace && \
    source /opt/ros/humble/setup.bash && \
    colcon build

WORKDIR /workspace

ENTRYPOINT [ "/ros_entrypoint.sh" ]
CMD ["/bin/bash"]
