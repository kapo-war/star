## Dockerfile version 0.0.0 ##

FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04 
SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND noninteractive
ENV MPLLOCALFREETYPE 1
RUN sed -i 's|http://archive.ubuntu|http://mirror.kakao|g' /etc/apt/sources.list
RUN sed -i 's|http://security.ubuntu|http://mirror.kakao|g' /etc/apt/sources.list

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV PATH=/opt/conda/bin:$PATH
ENV TZ=Asia/Seoul

RUN apt-get update --fix-missing
RUN apt-get upgrade -y
RUN apt-get install -y \
    build-essential cmake libtool autoconf unzip zip \
    bzip2 curl git tty-clock vim tmux wget dpkg \
    python3.11 python3-pip \
    golang

# copy and install requirements.txt
COPY requirements.txt /root/requirements.txt
RUN pip3 install -r /root/requirements.txt

# install sc2 linux pakage
RUN wget --quiet -O sc2.4.10.zip https://blzdistsc2-a.akamaihd.net/Linux/SC2.4.10.zip
RUN unzip -P iagreetotheeula sc2.4.10.zip -d /root/StarCraftII
RUN rm -rf sc2.4.10.zip

# test
COPY ./test /root/test
RUN sh /root/test/test.sh
RUN rm -rf /root/test

# remove cache
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*
