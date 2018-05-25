#!/bin/bash

DOCKER_USER=$(whoami)

if [ ! -d ~/.pulse_secure ]; then
  mkdir -p ~/.pulse_secure
fi

xhost +

docker run -it --rm \
-v /etc/localtime:/etc/localtime:ro \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v ~/.pulse_secure:/root/.pulse_secure \
--net host \
--privileged \
-e DISPLAY=unix$DISPLAY \
--name pulsesecure \
$DOCKER_USER/pulsesecure

