# http://docs.docker.com/examples/using_supervisord/

FROM ubuntu:latest
MAINTAINER examples@docker.io

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y openssh-server apache2 supervisor
RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor

RUN echo 'root:screencast' |chpasswd

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 22 80

CMD ["/usr/bin/supervisord"]


# docker build -t supervisord docker/supervisord
# docker run -p 22 -p 80 -t -i --name supervisord supervisord

# docker port sshd 22
# boot2docker ip
# ssh root@192.168.59.104 -p 49154