!SLIDE

## What is it?

* "open source project to pack, ship and run any application as a lightweight container”. 
 
* it works much like a virtual machine, wraps everything (filesystem, process management, environment variables, etc.) 
into a container. 

* Unlike a VM, it uses LXC (Linux kernel container) instead of a hypervisor. 

* LXC doesn’t have its own kernel, but shares the Linux kernel with the host and other containers instead. Based on LXC, 
Docker is so lightweight, that it introduces almost no performance drawback while running the application.

* provides a smart way to manage your images. Through Dockerfile and its caching mechanism, one can easily redeploy 
an updated image without transferring large amounts of data.


## When it make sense to use?

* With VM You have to upload the whole new image even if you just made a small update. With Docker
you don’t have to upload the whole image again. Docker is based on AuFS, which tracks the diff of the whole filesystem.

* There is a significant performance loss. With Docker The performance loss is ignorable since it runs on the host kernel.

* Your probably run your application on a VPS, which is already a virtualized environment. 
You can’t run a VM on top of another. You can run Docker on a VM because Docker is not a VM

## How it works?

* Docker needs to be run with root privelege.

Docker DOESN’T write into the image. Instead, it creates a layer with each Dockerfile line on top of the existing image, 
which contains the modifications you made to the filesystem. Migrating from a previous state of filesystem to 
a recent one is applying one or more layers on top of the old image, just like patching files.

When a container is stopped, you can commit it. Committing a container is creating an additional layer on top 
of the base image. As expected, the official ubuntu image is also made up of several layers.


## Installation

* Download and install VirtualBox for OSX

https://www.virtualbox.org/wiki/Downloads

* Install boot2docker and docker via homebrew:

```bash
brew install boot2docker
```
Docker will be installed as an dependency.

Initialize boot2docker virtual machine:

```bash
boot2docker init
```

Update .bash_profile file:


```bash
export DOCKER_HOST=tcp://192.168.59.103:2375
```

Start the docker daemon:

```bash
boot2docker up
```

or down:

```bash
boot2docker down
```

ssh it:

```bash
boot2docker ssh

# User: docker
# Pwd:  tcuser
```

Download the small base image named busybox:

```bash
docker pull busybox
docker pull ubuntu
docker pull centos
```

Run and test as separate command:

```bash
docker run ubuntu /bin/echo hello world
```

and interactively:


```bash
docker run -t -i ubuntu /bin/bash
```

```bash
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

# Build containers from Dockerfiles
docker build -t postgres docker/postgres
docker build -t demo demo

# Run and link the containers
docker run -d -p 5432:5432 --name postgres postgres:latest

docker run --rm -p 22 -p 9292:9292 --name demo demo:latest /bin/bash -l -c "rackup"

docker run -d -p 9292:9292 --name demo demo:latest /bin/bash -l -c "rackup"
``` 
 
```bash
boot2docker ip # 192.168.59.103

open http://192.168.59.103


docker run --rm ubuntu env

docker port demo 22

ssh root@localhost -p 49153

```



-d means run in the background

--name xyz gives the container the friendly name xyz which we can use to refer to it later when we want to 
stop it or link it to another container

-p 3000:3000 makes port 3000 from the container available as port 3000 on the host (the Virtualbox VM). Since we have Vagrant configured to forward port 3000 of the VM to your local machine 3000, you can access this container on port 3000 on your development machine as you would the normal Rails dev server (e.g. http://localhost:3000).

--link postgres:db establishes a link between the container you're starting (your Rails app) and the 
Postgres container you started previously. This is in the format name:alias and will make ports exposed by the 
Postgres container available to the Rails container.



!SLIDE

## Links

* Installing Docker on Mac OS X https://docs.docker.com/installation/mac/
* [Docker sources project = *https://github.com/dotcloud/docker*](https://github.com/dotcloud/docker)
* [Deploy Rails Applications Using Docker - *http://steveltn.me/blog/2014/03/15/deploy-rails-applications-using-docker*](http://steveltn.me/blog/2014/03/15/deploy-rails-applications-using-docker)
* [How to Skip Bundle Install When Deploying a Rails App to Docker if the Gemfile Hasn’t Changed - *http://ilikestuffblog.com/2014/01/06/how-to-skip-bundle-install-when-deploying-a-rails-app-to-docker*](http://ilikestuffblog.com/2014/01/06/how-to-skip-bundle-install-when-deploying-a-rails-app-to-docker)


http://www.talkingquickly.co.uk/2014/06/rails-development-environment-with-vagrant-and-docker
https://github.com/TalkingQuickly/docker_rails_dev_env/
https://coreos.com/docs/launching-containers/building/getting-started-with-docker
http://docs.docker.io/installation/binaries/#dockergroup
http://blog.gemnasium.com/post/65599561888/rails-meets-docker
https://github.com/gemnasium/rails-meets-docker
https://medium.com/@flawless_retard/a-osx-vagrant-docker-ruby-on-rails-setup-117daf4ef0a5
Docker Cheat Sheet - https://gist.github.com/wsargent/7049221


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

ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/rvm/gems/ruby-1.9.3-p547/bin


# Trick: make bundle command cashable

WORKDIR /tmp
ADD ./Gemfile Gemfile
ADD ./Gemfile.lock Gemfile.lock
RUN /bin/bash -l -c "rvm --create use 1.9.3@linux_provision_demo && bundle"

# Add project dir to docker

ADD . /opt/demo
WORKDIR /opt/demo

RUN /bin/bash -l -c "rvm use 1.9.3@linux_provision_demo && rake db:migrate"

#cd /app
#bundle exec rake db:drop db:create db:migrate


RUN chmod +x /opt/demo/bin/create_db.sh

# Make server port available outside
EXPOSE 9292

# Start server
#ENTRYPOINT /opt/demo/bin/start-server.sh
ENTRYPOINT /bin/bash -l -c "rackup"

#CMD ["/usr/bin/supervisord"]

