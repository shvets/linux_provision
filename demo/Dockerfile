FROM ubuntu:14.04

MAINTAINER Alexander Shvets "alexander.shvets@gmail.com"

# 1. Update system

RUN sudo apt-get update

RUN sudo locale-gen en_US.UTF-8

#RUN echo LANGUAGE="en_US.UTF-8" > /etc/default/locale
#RUN echo LC_ALL="en_US.UTF-8" > /etc/default/locale
#RUN echo LANG="en_US.UTF-8" > /etc/default/locale
#RUN echo LC_TYPE="en_US.UTF-8" > /etc/default/locale


# 2. Install sshd

RUN sudo apt-get install -y openssh-server

RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd

RUN sed --in-place=.bak 's/without-password/yes/' /etc/ssh/sshd_config

EXPOSE 22

CMD /usr/sbin/sshd -D


# 3. Create vagrant user

RUN groupadd vagrant
RUN useradd -d /home/vagrant -g vagrant -m -s /bin/bash vagrant

RUN sudo sed -i '$a vagrant    ALL=(ALL) NOPASSWD: ALL' /etc/sudoers

RUN echo vagrant:vagrant | chpasswd


# 4. Prepare directories for the project

# Add project dir to docker

ADD . /opt/demo
WORKDIR /opt/demo

EXPOSE 9292

# docker stop demo
# docker rm demo

# docker build -t demo demo
# docker run -d -p 42222:22 -p 9292:9292 --name demo demo
# ssh vagrant@192.168.59.103 -p 42222
# ssh root@192.168.59.103 -p 42222

# thor linux_install:general
# thor linux_install:service postgresql start
# thor linux_install:app

