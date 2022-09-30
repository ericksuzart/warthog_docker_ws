FROM osrf/ros:noetic-desktop-full

SHELL ["/bin/bash", "-c"]

LABEL app="ros1" \
      version="warthog-tutorials" \
      description="Imagem para a o workspace de tutorial do warthog" \
      maintainer="Erick Suzart Souza"

# install basic tools
RUN apt update && \
    sudo apt install -y \
        wget \
        git \
        python3-pip \
        locales \
        software-properties-common && \
    sudo pip3 install -U catkin_tools && \
    apt update

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

#ENV DEBIAN_FRONTEND=noninteractive

# install gpu driver
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y keyboard-configuration && \
#    sudo add-apt-repository ppa:kelebek333/nvidia-legacy && \
#    sudo apt install -y \
#        nvidia-340 

# install ROS packages
RUN sudo apt install -y \
    ros-noetic-warthog-desktop \
    ros-noetic-warthog-simulator \
    tree

RUN mkdir -p /workspace/src && \
    cd /workspace/src && \
    git clone -b kinetic-devel https://github.com/warthog-cpr/warthog.git && \
    source /opt/ros/noetic/setup.bash && \
    cd /workspace && \
    catkin build

WORKDIR /workspace

COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["/bin/bash"]

