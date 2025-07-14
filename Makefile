dev:
	docker pull ubuntu:focal
	docker build --build-arg UID=$$(id -u) --build-arg GID=$$(id -g) -t robotics:ros1-dev -f ros1/development/Dockerfile ros1/development
runtime:
	docker pull ros:noetic
	docker build --build-arg UID=$$(id -u) --build-arg GID=$$(id -g) -t robotics:ros1-runtime -f ros1/runtime/Dockerfile ros1/runtime
get-started:
	make dev
	make runtime
create-develop-container:
	xhost +local:
	docker run -itd \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v $$HOME/.ssh:/home/devuser/.ssh \
		-v $$HOME/sinfonia/:/home/devuser/sinfonia/ \
		-e DISPLAY=$$DISPLAY \
		--network host \
		--name sinfonia-dev \
		robotics:ros1-dev