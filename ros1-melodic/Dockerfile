FROM osrf/ros:melodic-desktop-full

SHELL ["/bin/bash", "-c"]

LABEL app="ros1" \
      version="melodic" \
      description="Imagem em ROS melodic para utilizar o MyntEYE SDK" \
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
        software-properties-common \
        curl \
        libv4l-dev && \
    sudo pip3 install -U catkin_tools && \
    # clean up
    apt autoremove -y && \
    apt clean -y && \
    rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=dialog

COPY src /workspace/src

WORKDIR /workspace

# build
RUN source /opt/ros/melodic/setup.bash && \
    cd src/MYNT-EYE-S-SDK && \
    make ros

ENTRYPOINT [ "/ros_entrypoint.sh" ]
CMD ["/bin/bash"]
