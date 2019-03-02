#!/bin/bash

DOCKER_USER=$(whoami)
DOCKER_RUN_PARAMS=""

if [ ! -d ~/.pulse_secure ]; then
  mkdir -p ~/.pulse_secure
fi

xhost +

if echo $TERM | grep -q xterm; then
	DOCKER_RUN_PARAMS="-it"
fi

docker run $DOCKER_RUN_PARAMS --rm \
-v /etc/localtime:/etc/localtime:ro \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v ~/.pulse_secure:/root/.pulse_secure \
--net host \
--privileged \
-e DISPLAY=unix$DISPLAY \
--name pulsesecure \
$DOCKER_USER/pulsesecure

