# Docker Utilities - SinfonIA

## Overview

This repository provides core utilities for initializing SinfonIA development environments using Docker. GNU Make is recommended to simplify common operations.

Prerequisites:
- Docker installed and working
- (Optional) NVIDIA Container Toolkit for GPU targets
- Recommended: GNU Make

## Quick Start

To set up images used by SinfonIA, run:

```bash
make get-started
```

This will run `make dev` and `make runtime`. Expect the full process to take up to ~30 minutes depending on network and machine speed.

## Makefile variables

- SINFONIA_PATH (default: $HOME/Documents/docker) — base path used by container run targets to mount local workspaces.
- Build arguments passed to some Docker builds:
  - UID (default: current user's id)
  - GID (default: current user's group id)

You can override them on the command line:
```bash
make dev UID=1001 GID=1001
make dev-jazzy UID=1001 GID=1001
```

## Make targets

- dev
  - Builds the ROS Noetic development image `robotics:ros1-dev` from `ros1/development/Dockerfile`.
  - Pulls `ubuntu:focal` first.
  - Supports build-args UID and GID to match host user permissions.

- dev-jazzy
  - Builds the ROS 2 Jazzy development image `robotics:ros2-jazzy-dev` from `ros2/jazzy/Dockerfile`.
  - Note: the Dockerfile uses an Ubuntu base appropriate for Jazzy.

- dev-unitree
  - Builds the Unitree ROS2 image at `ros2/unitree/Dockerfile`.

- runtime
  - Builds the runtime image `robotics:ros1-runtime` (pulls `ros:noetic`).

- get-started
  - Shorthand that runs `make dev` then `make runtime`.

- create-develop-container
  - Runs a detached development container named `sinfonia-dev` from `robotics:ros1-dev`.
  - Key mounts and flags:
    - X11 socket: `-v /tmp/.X11-unix:/tmp/.X11-unix` and `-e DISPLAY=$DISPLAY` (for GUI apps)
    - SSH keys: `-v $HOME/.ssh:/home/devuser/.ssh`
    - Workspace mount: `-v $(SINFONIA_PATH)/ros1_workspaces:/home/devuser/sinfonia/`
    - Devices: `/dev/video0`, `/dev/video1`
    - Adds supplementary groups used for media devices (`--group-add 44`, `--group-add 985`)
    - Host networking (`--network host`)
    - Sets `SINFONIA_WS` env var inside the container

- create-develop-container-gpu
  - Same as above plus GPU runtime flags: `--runtime=nvidia --gpus all`.

- create-develop-container-jazzy-gpu
  - Similar to GPU container but mounts `ros2_workspaces` and names the container `sinfonia-jazzy-dev`, using the ROS2 Jazzy image.

- delete-develop-container
  - Stops and removes the `sinfonia-dev` container.

- connect-develop-container
  - Attaches a shell: `docker exec -it sinfonia-dev bash`.

## Examples

Build and run a dev container (GPU):
```bash
make dev
make create-develop-container-gpu
```

Build with a specific UID/GID:
```bash
make dev UID=$(id -u) GID=$(id -g)
```

Run jazzy GPU container:
```bash
make dev-jazzy
make create-develop-container-jazzy-gpu
```

## Troubleshooting & Notes

- If GUI apps can't connect to X11, allow local connections before running the container:
  ```bash
  xhost +local:
  ```
- If workspace mount points differ, override SINFONIA_PATH when invoking make:
  ```bash
  make create-develop-container SINFONIA_PATH=/path/to/your/docker
  ```
- Builds and image downloads can be large; ensure you have sufficient disk space and patience for the first run.

## Compatibility

Tested on WSL and Linux. macOS may work but is unverified.
