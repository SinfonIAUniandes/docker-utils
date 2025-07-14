FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

# SDK installation

RUN apt-get update
RUN apt-get install -y git gcc make cmake g++ libeigen3-dev

RUN mkdir /root/g1_dk

WORKDIR /root/g1_dk

RUN git clone  https://github.com/unitreerobotics/unitree_sdk2.git

RUN mkdir /root/g1_dk/unitree_sdk2/build

WORKDIR /root/g1_dk/unitree_sdk2/build

RUN cmake ..

RUN make install

WORKDIR /root/g1_dk

# ROS2Foxy installation

RUN apt-get install -y locales
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN apt install -y software-properties-common
RUN add-apt-repository universe
RUN apt-get install curl -y
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN apt update
RUN apt upgrade -y
RUN apt install -y ros-foxy-desktop python-is-python3 python3-argcomplete

RUN echo "source /opt/ros/foxy/setup.bash" >> /root/.bashrc

ENTRYPOINT ["/bin/bash", "-c", "exec \"$@\"", "--"]