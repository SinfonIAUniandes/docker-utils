#  ROS 2 Humble requires Ubuntu Jammy (22.04)
FROM ubuntu:jammy

ENV DEBIAN_FRONTEND=noninteractive

# Set timezone and basic tools
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends tzdata && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y lsb-release gnupg curl vim wget net-tools locales software-properties-common

# Locale setup for ROS 2
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN export LANG=en_US.UTF-8

# Enable Ubuntu Universe
RUN add-apt-repository universe

#  Install ROS 2 Humble Desktop
# We use the official ROS 2 GPG key and repository for Jammy
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN apt-get update && apt-get install -y \
    ros-humble-desktop \
    python3-colcon-common-extensions \
    python3-argcomplete \
    python-is-python3 \
    python3-pip \
    build-essential \
    sudo

# --- NVIDIA GPU SUPPORT ---
#  Environment variables for NVIDIA Container Toolkit
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute
# Fix for some GUI apps (like Gazebo/Rviz) over X11
ENV QT_X11_NO_MITSHM 1 

# User setup (matching your existing SinfonIA pattern)
ARG UID=1000
ARG GID=1000

# Remove default ubuntu user if it exists to avoid UID conflicts
RUN touch /var/mail/ubuntu && chown ubuntu /var/mail/ubuntu && userdel -r ubuntu || true

RUN groupadd -g ${GID} devgroup
RUN useradd -m -u ${UID} -g ${GID} -s /bin/bash devuser
RUN usermod -aG sudo devuser && echo 'devuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER devuser
WORKDIR /home/devuser/sinfonia/

# [cite: 4] Source ROS 2 Humble automatically
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN echo "alias reload=\"source ~/.bashrc\"" >> ~/.bashrc

ENTRYPOINT ["/bin/bash"]