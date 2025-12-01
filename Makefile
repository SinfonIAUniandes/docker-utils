SINFONIA_PATH ?= $$HOME/Documents/docker

dev:
	docker pull ubuntu:focal
	docker build --build-arg UID=$$(id -u) --build-arg GID=$$(id -g) -t robotics:ros1-dev -f ros1/development/Dockerfile ros1/development
dev-unitree:
	docker pull ubuntu:focal
	docker build -t robotics:unitree-g1-ros2 -f ros2/unitree/Dockerfile ros2/unitree
dev-jazzy:
	docker pull ubuntu:focal
	docker build --build-arg UID=$$(id -u) --build-arg GID=$$(id -g) -t robotics:ros2-jazzy-dev -f ros2/jazzy/Dockerfile ros2/jazzy
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
		--group-add 44 \
		--group-add 985 \
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
		--device /dev/video0:/dev/video0 \
		--device /dev/video1:/dev/video1 \
		--group-add 44 \
		--group-add 985 \
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
		--device /dev/video0:/dev/video0 \
		--device /dev/video1:/dev/video1 \
		--group-add 44 \
		--group-add 985 \
		--network host \
		--name sinfonia-jazzy-dev \
		--runtime=nvidia \
		--gpus all \
	robotics:ros2-jazzy-dev
delete-develop-container:
	docker stop sinfonia-dev
	docker rm sinfonia-dev
connect-develop-container:
	docker exec -it sinfonia-dev bash
