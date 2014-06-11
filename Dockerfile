FROM ubuntu:12.04

RUN apt-get update

RUN apt-get install -y curl
RUN apt-get install -y g++
RUN apt-get install -y subversion

EXPOSE 3000
USER rails

#CMD /start