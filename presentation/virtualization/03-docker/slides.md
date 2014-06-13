!SLIDE

## Introduction

## What is it?

## Features

* Linux Containers

* automatic caching mechanism to greatly speed things up after the first build of a Dockerfile

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
export DOCKER_HOST=tcp://127.0.0.1:4243
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
docker run -t -i ubuntu /bin/bash
```

and interactively:


```bash
docker run -t -i ubuntu /bin/bash
```

```bash
docker build -t demo .
```

```bash
docker run -p 49160:8080 -d busybox
```


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