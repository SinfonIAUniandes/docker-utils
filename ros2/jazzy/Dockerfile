FROM ubuntu:noble

ENV DEBIAN_FRONTEND=noninteractive

RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends tzdata && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y lsb-release gnupg

RUN apt-get install curl vim wget net-tools -y

RUN locale  # check for UTF-8

RUN apt-get install -y locales
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN export LANG=en_US.UTF-8

RUN apt install -y software-properties-common
RUN add-apt-repository universe

RUN apt-get install curl -y

RUN export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}') && \
    curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb" && \
    dpkg -i /tmp/ros2-apt-source.deb

RUN apt update
RUN apt install -y ros-jazzy-desktop python-is-python3 python3-argcomplete
RUN apt-get install python3-pip build-essential -y

RUN apt-get install -y python-is-python3
ARG UID=1000
ARG GID=1000

RUN groupadd -o -g ${GID} devgroup || true
RUN useradd -m -o -u ${UID} -g ${GID} devuser || true

RUN apt-get update && apt-get install -y sudo \
 && usermod -aG sudo devuser \
 && echo 'devuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN sudo apt-get install nano -y

USER devuser

RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc
RUN echo "alias reload=\"source ~/.bashrc\"" >> ~/.bashrc

WORKDIR /home/devuser/sinfonia/

ENTRYPOINT ["/bin/bash"]
