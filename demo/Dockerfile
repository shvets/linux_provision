FROM ubuntu

# General packages

RUN apt-get update

RUN apt-get install -y curl
RUN apt-get install -y g++
RUN apt-get install -y  git

# Install rvm

RUN curl -L https://get.rvm.io | bash

# Install ruby

RUN /bin/bash -l -c "rvm install ruby-1.9.3"

# Install project

# Copy the app into the image.
ADD . /demo

ADD docker/start-server.sh /usr/bin/start-server.sh
RUN chmod +x /usr/bin/start-server.sh

WORKDIR /demo

RUN /bin/bash -l -c "bundle"

RUN /bin/bash -l -c "rake db:migrate"

EXPOSE 9292

ENTRYPOINT /usr/bin/start-server.sh
