FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends tzdata && \
    rm -rf /var/lib/apt/lists/*


# Install lsb-release (it might not be present by default)
RUN apt-get update && apt-get install -y lsb-release gnupg

# Setup sources.list (corrected to specify architecture)
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'


RUN apt-get install -y curl
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
# Installation
RUN apt-get update
RUN apt-get install -y ros-noetic-desktop-full

# Dependencies for building packages
RUN apt-get update
RUN apt-get install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential

# Initialize rosdep
RUN apt-get update
RUN apt-get install -y python3-rosdep

RUN apt-get install -y python-is-python3
RUN apt-get install -y python3-pip

RUN rosdep init
RUN rosdep update

# Execute (setup environment and start bash)
RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc

WORKDIR /root

ENTRYPOINT ["/bin/bash", "-c", "source /opt/ros/noetic/setup.bash && exec \"$@\"", "--"]


