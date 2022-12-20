#!/bin/bash
XAUTH=/tmp/.docker.xauth
xhost +local:docker

echo "Preparing Xauthority data..."
xauth_list=$(xauth nlist :0 | tail -n 1 | sed -e 's/^..../ffff/')
if [ ! -f $XAUTH ]; then
    if [ ! -z "$xauth_list" ]; then
        echo $xauth_list | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

echo "Done."
echo "Running docker..."

BASEDIR=$(pwd -P)

# Define Docker volumes and environment variables
DOCKER_VOLUMES="
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="$XAUTH:$XAUTH" \
    --volume="/etc/group:/etc/group:ro" \
    --volume="/etc/passwd:/etc/passwd:ro" \
    --volume="/etc/shadow:/etc/shadow:ro" \
    --volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
    --volume="/workspace" \
    --volume="${BASEDIR}/src":"/workspace/src":rw \
"

DOCKER_ENV_VARS="
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --env="XAUTHORITY=$XAUTH" \
    --env="NVIDIA_VISIBLE_DEVICES=all" \
    --env="NVIDIA_DRIVER_CAPABILITIES=all" \
"

DOCKER_CONFIG="
    --net=host \
    --ipc=host \
    --runtime=nvidia \
"

# check for devices
DEVICES=" "

for i in {0..9}
do
    if [ -a "/dev/video${i}" ]; then
        DEVICES="${DEVICES} --device="/dev/video${i}" "
    fi
done

DOCKER_ARGS=${DOCKER_VOLUMES}" "${DOCKER_ENV_VARS}" "${DOCKER_CONFIG}" "${DEVICES}

docker run -it \
    ${DOCKER_ARGS} \
    ros1:warthog-melodic \
    bash

echo "Finished."
