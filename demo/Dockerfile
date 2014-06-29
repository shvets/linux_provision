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

# 4. Install project

# Trick: make bundle command cashable

WORKDIR /tmp
ADD ./Gemfile Gemfile
ADD ./Gemfile.lock Gemfile.lock
RUN /bin/bash -l -c "rvm --create use 1.9.3@linux_provision_demo && bundle"

# Add project dir to docker

ADD . /opt/demo
WORKDIR /opt/demo

# Add 'web' user which will run the application
#RUN adduser web --home /home/web --shell /bin/bash --disabled-password --gecos ""

#RUN chown -R web:web /var/www &&\
#  mkdir -p /var/bundle &&\
#  chown -R web:web /var/bundle
#RUN su -c "cd /var/www && bundle install --deployment --path /var/bundle" -s /bin/bash -l web
#RUN chown -R web:web /var/www
#USER web

#RUN chmod +x /opt/demo/bin/create_db.sh
#RUN /bin/bash -l -c "rvm use 1.9.3@linux_provision_demo && rake db:migrate"

# Make server port available outside
EXPOSE 9292

# Start server
#ENTRYPOINT /opt/demo/bin/start-server.sh

CMD /bin/bash -l -c "rackup"

# 2. Install sshd

#RUN apt-get install -y openssh-server supervisor

#RUN mkdir /var/run/sshd
#RUN mkdir -p /var/log/supervisor

#RUN echo 'root:screencast' | chpasswd

#EXPOSE 22

#CMD /usr/sbin/sshd -D

#ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#CMD ["/usr/bin/supervisord"]

# boot2docker ip

# docker build -t demo demo
# docker run --rm -p 9292:9292 -e POSTGRESQL_HOST='192.168.59.104' --name demo demo /bin/bash -l -c "rake db:migrate"
# docker run --rm -p 9292:9292 -e POSTGRESQL_HOST='192.168.59.104' --name demo demo /bin/bash -l -c "rackup"

# docker build -t demo demo
# docker run -d -p 42222:22 -p 80:80 --name demo demo

# docker run -p 42222:22 -p 80:80 -t -i --name demo demo

# docker port sshd 22
# boot2docker ip
# ssh root@192.168.59.103 -p 42222

# docker run -d -p 42222:22 -p 9292:9292 --name demo demo
