FROM ros:noetic

RUN apt-get update && apt-get install -y python3-pip python-is-python3
RUN pip install --upgrade pip

ENV ROS_WORKSPACE=/catkin_ws
ENV ROS_MASTER_URI=http://localhost:11311

RUN mkdir -p /catkin_ws/src

WORKDIR /root

COPY ./entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]