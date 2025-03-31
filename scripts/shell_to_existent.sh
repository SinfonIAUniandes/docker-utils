#!/bin/bash

# Permitir acceso a la pantalla
xhost +local:

# Ejecutar el contenedor con acceso a la GPU y pantalla
docker exec -it -e DISPLAY=$DISPLAY rosenv bash
