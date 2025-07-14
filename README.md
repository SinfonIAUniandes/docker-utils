# Docker Utilities - SinfonIA

## Overview

This repository provides core utilities for initializing SinfonIA development environments. It requires **Docker** and recommends **GNU Make** for simplified script execution.

## Quick Start

To set up your development environment, run:

```bash
make get-started
````

This command may take up to **30 minutes** and performs the following actions (by calling make dev and make runtime):

  * Pulls essential Docker images: `ubuntu:focal` and `ros:noetic`.
  * Constructs two Docker containers:
      * `robotics:ros1-dev`: Your dedicated development environment.
      * `robotics:ros1-runtime`: The environment for running your applications.

## Development Container

To create and launch the development container, execute:

```bash
make create-develop-container
```

This command initiates a detached, interactive container named `sinfonia-dev` with the following configurations:

  * **GUI Support**: Mounts the X11 socket.
  * **SSH Access**: Mounts your host's SSH directory, enabling key access within the container.
  * **Persistent Source Code**: Mounts the `sinfonia` directory.
  * **Network & Display**: Configures host networking and forwards the display for graphical tools.


## Production Containers

In production environments, such as the Pepper robot or the nvidia jetson nano, only use the production container:

```bash
make runtime
```

This command only constructs `robotics:ros1-runtime`: The environment for running your applications.

## Compatibility

This utility has been tested and verified on **WSL** (Windows Subsystem for Linux) and **Linux** distributions. Compatibility with **macOS** has not been confirmed but is expected to work properly.
