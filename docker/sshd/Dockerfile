# https://registry.hub.docker.com/u/dhrp/sshd/
# http://stackoverflow.com/questions/23014684/how-to-get-ssh-connection-with-docker-container-on-osxboot2docker

# sshd
#
# VERSION               0.0.1

FROM     ubuntu
MAINTAINER Thatcher R. Peskens "thatcher@dotcloud.com"

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:screencast' |chpasswd

EXPOSE 22

CMD /usr/sbin/sshd -D

# docker build -t sshd docker/sshd
# docker run -d -P --name sshd sshd

# docker port sshd 22
# boot2docker ip
# ssh root@192.168.59.104 -p 49153
