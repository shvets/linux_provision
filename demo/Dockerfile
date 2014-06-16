FROM ubuntu:14.04

MAINTAINER Alexander Shvets "alexander.shvets@gmail.com"

# 1. Install general packages

RUN apt-get update

RUN apt-get install -y curl
RUN apt-get install -y g++
RUN apt-get install -y  git
RUN apt-get -y -q install libpq-dev

# for rvm
RUN apt-get -y -q install gawk make libreadline6-dev libyaml-dev libsqlite3-dev sqlite3
RUN apt-get -y -q install autoconf libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev

# 2. Install sshd

RUN apt-get install -y openssh-server

RUN mkdir /var/run/sshd
#RUN mkdir -p /var/log/supervisor

RUN echo 'root:screencast' |chpasswd

EXPOSE 22

CMD /usr/sbin/sshd -D


