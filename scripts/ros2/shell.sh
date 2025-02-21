#!/bin/bash

# Verificar que se ha pasado un argumento
if [ "$#" -lt 1 ]; then
    echo "Uso: $0 <ruta_a_la_carpeta>"
    exit 1
fi

# Obtener el path absoluto
HOST_DIR=$(realpath "$1")

# Verificar que es una carpeta válida
if [ ! -d "$HOST_DIR" ]; then
    echo "Error: '$HOST_DIR' no es una carpeta válida."
    exit 1
fi

# Permitir acceso a la pantalla
xhost +local:

# Ejecutar el contenedor con acceso a la GPU y pantalla
docker run -it --rm \
    --gpus all \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "$HOST_DIR:/root/sinfonia" \
    --device=/dev/dri:/dev/dri \
    --device=/dev/nvidia0 --device=/dev/nvidiactl --device=/dev/nvidia-modeset \
    --ipc=host \
    --network host \
    --entrypoint /bin/bash \
    ubuntu_ros2_g1
