SINFONIA_PATH ?= $$HOME/Documentos/docker

dev:
	docker pull ubuntu:focal
	docker build \
		--build-arg UID=$$(id -u) \
		--build-arg GID=$$(id -g) \
		--build-arg VIDEO_GID=$(shell getent group video | cut -d: -f3) \
		--build-arg RENDER_GID=$(shell getent group render | cut -d: -f3) \
		-t robotics:ros1-dev -f ros1/development/Dockerfile ros1/development $(ARGS)
dev-unitree:
	docker pull ubuntu:focal
	docker build -t robotics:unitree-g1-ros2 -f ros2/unitree/Dockerfile ros2/unitree
dev-jazzy:
	docker pull ubuntu:focal
	docker build --build-arg UID=$$(id -u) --build-arg GID=$$(id -g) -t robotics:ros2-jazzy-dev -f ros2/jazzy/Dockerfile ros2/jazzy
dev-humble:
	docker pull ubuntu:jammy
	docker build --build-arg UID=$$(id -u) --build-arg GID=$$(id -g) \
		-t robotics:ros2-humble-dev -f ros2/humble/Dockerfile ros2/humble
runtime:
	docker pull ros:noetic
	docker build -t robotics:ros1-runtime -f ros1/runtime/Dockerfile ros1/runtime
get-started:
	make dev
	make runtime
create-develop-container:
	xhost +local:
	docker run -itd \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v $$HOME/.ssh:/home/devuser/.ssh \
		-v $(SINFONIA_PATH)/ros1_workspaces:/home/devuser/sinfonia/ \
		-e DISPLAY=$$DISPLAY \
		-e SINFONIA_WS=/home/devuser/sinfonia/ \
		--device /dev/video0:/dev/video0 \
		--device /dev/video1:/dev/video1 \
		--group-add $(shell getent group video | cut -d: -f3) \
		--group-add $(shell getent group render | cut -d: -f3) \
		--network host \
		--name sinfonia-dev \
		robotics:ros1-dev
create-develop-container-gpu:
	xhost +local:
	docker run -itd \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v $$HOME/.ssh:/home/devuser/.ssh \
		-v $(SINFONIA_PATH)/ros1_workspaces:/home/devuser/sinfonia/ \
		-e DISPLAY=$$DISPLAY \
		-e SINFONIA_WS=/home/devuser/sinfonia/ \
		$(shell [ -c /dev/video0 ] && echo "--device /dev/video0:/dev/video0") \
		$(shell [ -c /dev/video1 ] && echo "--device /dev/video1:/dev/video1") \
		--group-add $(shell getent group video | cut -d: -f3) \
		--group-add $(shell getent group render | cut -d: -f3) \
		--network host \
		--name sinfonia-dev \
		--runtime=nvidia \
		--gpus all \
		robotics:ros1-dev
create-develop-container-jazzy-gpu:
	xhost +local:
	docker run -itd \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v $$HOME/.ssh:/home/devuser/.ssh \
		-v $(SINFONIA_PATH)/ros2_workspaces:/home/devuser/sinfonia/ \
		-e DISPLAY=$$DISPLAY \
		-e SINFONIA_WS=/home/devuser/sinfonia/ \
		-e QT_X11_NO_MITSHM=1 \
		-e NVIDIA_VISIBLE_DEVICES=all \
		-e NVIDIA_DRIVER_CAPABILITIES=all \
		$(shell [ -c /dev/video0 ] && echo "--device /dev/video0:/dev/video0") \
		$(shell [ -c /dev/video1 ] && echo "--device /dev/video1:/dev/video1") \
		--device /dev/dri:/dev/dri \
		--group-add $(shell getent group video | cut -d: -f3) \
		--group-add $(shell getent group render | cut -d: -f3) \
		--network host \
		--name sinfonia-jazzy-dev \
		--runtime=nvidia \
		--gpus all \
		robotics:ros2-jazzy-dev
create-develop-container-humble-gpu:
	xhost +local:
	docker run -itd \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v $$HOME/.ssh:/home/devuser/.ssh \
		-v $(SINFONIA_PATH)/humble_workspaces:/home/devuser/sinfonia/ \
		-e DISPLAY=$$DISPLAY \
		-e SINFONIA_WS=/home/devuser/sinfonia/ \
		-e QT_X11_NO_MITSHM=1 \
		$(shell [ -c /dev/video0 ] && echo "--device /dev/video0:/dev/video0") \
		$(shell [ -c /dev/video1 ] && echo "--device /dev/video1:/dev/video1") \
		--device /dev/dri:/dev/dri \
		--group-add $(shell getent group video | cut -d: -f3) \
		--group-add $(shell getent group render | cut -d: -f3) \
		--network host \
		--name sinfonia-humble-dev \
		--runtime=nvidia \
		--gpus all \
		robotics:ros2-humble-dev
delete-develop-container:
	docker stop sinfonia-dev
	docker rm sinfonia-dev
connect-develop-container:
	docker exec -it sinfonia-dev bash
