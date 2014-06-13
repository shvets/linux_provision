FROM ubuntu

# General packages

RUN apt-get update

RUN apt-get install -y curl
RUN apt-get install -y g++
RUN apt-get install -y  git

RUN apt-get install -y postgresql-client
RUN apt-get install -y libpq-dev
RUN apt-get install -y postgresql

# Install rvm

RUN curl -L https://get.rvm.io | bash

# Install ruby

RUN /bin/bash -l -c "rvm install ruby-1.9.3"

# Install project

# Copy the Gemfile and Gemfile.lock into the image.
# Temporarily set the working directory to where they are.

WORKDIR /tmp
ADD demo/Gemfile Gemfile
ADD demo/Gemfile.lock Gemfile.lock
#RUN bundle install
RUN /bin/bash -l -c "bundle"

# Everything up to here was cached. This includes
# the bundle install, unless the Gemfiles changed.
# Now copy the app into the image.

ADD demo /opt/demo

WORKDIR /opt/demo

ADD docker/start-server.sh /usr/bin/start-server.sh
RUN chmod +x /usr/bin/start-server.sh


#RUN /bin/bash -l -c "bundle"
#RUN /bin/bash -l -c "source /home/docker/.rvm/scripts/rvm"
#RUN bundle install

RUN /bin/bash -l -c "rake db:migrate"

EXPOSE 9292

ENTRYPOINT /usr/bin/start-server.sh
