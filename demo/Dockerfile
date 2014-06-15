FROM ubuntu

MAINTAINER Alexander Shvets "alexander.shvets@gmail.com"

# 1. Install general packages

RUN apt-get update

RUN apt-get install -y curl
RUN apt-get install -y g++
RUN apt-get install -y  git
RUN apt-get -y -q install libpq-dev

# 2. Install sshd

#RUN apt-get install -y openssh-server

#RUN mkdir /var/run/sshd
#RUN echo 'root:screencast' |chpasswd

#EXPOSE 22

#CMD /usr/sbin/sshd -D

# 3. Install postgres

#RUN apt-get -y -q install postgresql-9.3 postgresql-client-9.3 postgresql-contrib-9.3

#USER postgres

#ADD bin/create_db.sh /src/
#RUN /src/create_db.sh

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
#RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.3/main/pg_hba.conf

# And add ``listen_addresses`` to ``/etc/postgresql/9.3/main/postgresql.conf``
#RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf

# Expose the PostgreSQL port
#EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
#VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Set the default command to run when starting the container
#CMD ["/usr/lib/postgresql/9.3/bin/postgres", "-D", "/var/lib/postgresql/9.3/main", "-c", "config_file=/etc/postgresql/9.3/main/postgresql.conf"]

#USER root

# 3. Install rvm & ruby

RUN curl -L https://get.rvm.io | bash

RUN /bin/bash -l -c "source /etc/profile.d/rvm.sh && rvm install ruby-1.9.3"

#RUN /usr/local/rvm/bin/rvm-shell -c -l 'rvm install 2.1.1'
#RUN /usr/local/rvm/bin/rvm-shell -c -l 'rvm use 2.1.1'
#RUN /usr/local/rvm/bin/rvm-shell -c -l 'gem install bundler --no-ri --no-rdoc'

# 4. Install project

# Trick: make bundle command cashable

WORKDIR /tmp
ADD ./Gemfile Gemfile
ADD ./Gemfile.lock Gemfile.lock
RUN /bin/bash -l -c "rvm --create use 1.9.3@linux_provision_demo && bundle"

# Add project dir to docker

ADD . /opt/demo
WORKDIR /opt/demo

#RUN /bin/bash -l -c "rvm use 1.9.3@linux_provision_demo && rake db:migrate"

# Make server port available outside

EXPOSE 9292

# Start server

ENTRYPOINT /opt/demo/bin/start-server.sh