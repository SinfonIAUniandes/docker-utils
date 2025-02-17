#!/bin/bash

# Permitir acceso a la pantalla
xhost +local:

# Ejecutar el contenedor con acceso a la GPU y pantalla
docker run -it --rm \
    --gpus all \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --device=/dev/dri:/dev/dri \
    --device=/dev/nvidia0 --device=/dev/nvidiactl --device=/dev/nvidia-modeset \
    --ipc=host \
    --network host \
    ros-env \
    roscore
