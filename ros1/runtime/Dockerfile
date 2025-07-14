FROM ros:noetic

ARG UID=1000
ARG GID=1000

RUN groupadd -g ${GID} devgroup \
 && useradd -m -u ${UID} -g ${GID} devuser

RUN apt-get update && apt-get install -y python3-pip

RUN apt-get update && apt-get install -y sudo \
 && usermod -aG sudo devuser \
 && echo 'devuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER devuser

WORKDIR /root

ENTRYPOINT ["/bin/bash"]