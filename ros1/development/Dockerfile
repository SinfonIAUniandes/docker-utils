FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive

RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends tzdata && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y lsb-release gnupg

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

RUN apt-get install curl vim wget net-tools -y

RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

RUN apt-get update

RUN apt-get install ros-noetic-desktop-full -y

RUN apt-get install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential -y

RUN apt-get install python3-rosdep

ARG UID=1000
ARG GID=1000

RUN groupadd -g ${GID} devgroup \
 && useradd -m -u ${UID} -g ${GID} devuser

RUN apt-get update && apt-get install -y sudo \
 && usermod -aG sudo devuser \
 && echo 'devuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN rosdep init

USER devuser

RUN rosdep update

RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc

WORKDIR /home/devuser/sinfonia/

ENTRYPOINT ["/bin/bash"]