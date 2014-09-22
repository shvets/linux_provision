# Library and thor tasks for provisioning of Linux computer initial setup for Ruby/Rails development


## Introduction


Why do we need virtualization in development?

* We want to have **same environment for all developers**, no matter on what platform they are working now.

* We are **working on multiple projects** on same computer unit. As a result, suddenly your computer has "hidden",
hard-to-discover inter-project dependencies or different versions of the same library.

* We want to run Continuous Integration Server's jobs that start services on **same ports** for different set
of acceptance tests (isolated jobs).

* To overcome **It works on my machine!** syndrome - development environment is different from production environment.

* Sometimes required software is **not available** on developer's platform. Example: 64-bit instant client for oracle
was broken for almost two years on OSX  >= 10.7.

* **Development for PAAS**, such as Heroku, Engine Yard etc. You can find and build virtualization that is pretty close to
your platform.

We will take a look at how can we do provisioning for **Vagrant** and **Docker**. Both tools are built based on **VirtualBox**.


## Installing and configuring Vagrant


Vagrant is wrapper around Virtual Box. It is a tool for managing virtual machines via a simple to use command line interface. With it you can work in a clean environment based on a standard template - **base box**.

In order to use Vagrant you have to install these programs:

* [VirtualBox][VirtualBox]. Download it from dedicated web site and install
it as native program. You can use it in UI mode, but it's not required.

* [Vagrant][Vagrant]. Before it was distributed as ruby gem, now it's packaged as **native application**. Once installed, it will be accessible from command line as **vagrant** command.

You have to decide what linux image feets your needs. Here we use **Ubuntu 14.04 LTS 64-bit** image - it is identified as **ubuntu/trusty64**.

Download and install it:

```bash
vagrant box add ubuntu/trusty64 https://vagrantcloud.com/ubuntu/boxes/trusty64
```

Initialize it:

```
vagrant init ubuntu/trusty64
```

This command creates **Vagrantfile** file in the root of your project. Below is an example of such a file:

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
end
```

You can do various commands with **vagrant** tool. For example:

```bash
vagrant up        # starts up: creates and configures guest machine
vagrant suspend   # suspends the guest machine
vagrant halt      # shuts down the running machine
vagrant reload    # vagrant halt; vagrant up
vagrant destroy   # stops machine and destroys all related resources
vagrant provision # perform provisioning for machine
vagrant box remove ubuntu/trusty64 # removes a box from vagrant

# packages a currently running VirtualBox environment into a re-usable box.
vagrant package --vagrantfile Vagrantfile --output linux_provision.box
```

After **Vagrantfile** is generated, you can start your base box:

```bash
vagrant up
```

Now you have a **fully running virtual machine** in VirtualBox. You can access it through **vagrant ssh** command:

```bash
vagrant ssh
```

or **directly via ssh** (use **vagrant** password for **vagrant** user and port **2222**, this port is used as default by vagrant for ssh connections):

```bash
ssh vagrant@127.0.0.1 -p 2222
```

You can assign IP address for your linux box, e.g.:

```ruby
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.network "private_network", ip: "22.22.22.22"
end
```

With this configuration you can access ssh on default port:

```bash
ssh vagrant@22.22.22.22
```

Your linux box initial setup is completed now and ready to use.


## Installing and configuring Docker


Docker is an open-source project that helps you to create and manage **Linux containers**. Containers are like extremely lightweight VMs - they allow code to run in isolation from other containers. They safely share the machine's resources, all without the overhead of a hypervisor.

In order to use Docker you have to install these programs:

* [VirtualBox][VirtualBox].

* [boot2docker][boot2docker]. You need to install it only for non-Linux environment.

 boot2docker is a lightweight Linux image made specifically to run Docker containers. It runs completely from RAM, weighs  approximately 27 MB and boots in about 5 seconds.

We'll run the Docker client natively on OSX, but the Docker server will run inside our boot2docker VM. This also means boot2docker, not OSX, is the Docker host.

This command will create **boot2docker-vm** virtual machine:

```bash
boot2docker init
```

Start it up:

```bash
boot2docker up
```

or shut it down:

```bash
boot2docker down
```

Upgrade Boot2docker VM image:

```bash
boot2docker stop
boot2docker download
boot2docker up
```

When docker daemon first started, it gives you recommendation about how to run docker client.
It needs to know where docker is running, e.g.:

```bash
export DOCKER_HOST=tcp://192.168.59.103:2375
```

You have to setup it globally in **.bash\_profile** file or specify it each time when docker client is started.

You can access boot2docker over ssh (user: **docker**, password: **tcuser**):

```bash
boot2docker ssh
```

Download the small base image named **busybox**:

```bash
docker pull busybox
```

Run and test docker as separate command:

```bash
docker run busybox echo "hello, linus!"
```

or interactively:

```bash
docker run -t -i busybox /bin/sh
```


## Install and confige linux_provision gem

Both programs - Vagrant and Docker - have their own ways to serve provisioning. Vagrant is doing it with the help of **provision** attribute. Example with simple shell script:

```ruby
Vagrant::Config.run do |config|
  config.vm.provision :shell, :path => "bootstrap.sh"
end
```
or with chef solo:

```ruby
Vagrant::Config.run do |config|
  config.vm.provision :chef_solo do |chef|
    ...
  end
end
```
Docker also lets you do provisioning in form of **RUN** command:

```text
# Dockerfile

RUN apt-get -y -q install postgresql-9.3
```

After multiple experiments with provisions both from Vagrant and Docker it was discovered that it is not convenient to use. It does not let you to easy install or uninstall separate packages. It's better to do it as **set of independent scripts**, separated completely from Docker and Vagrant.

**linux_provision** gem is set of such shell scripts - they install various components like postgres server, rvm, ruby etc. with the help of thor or rake script. You can see other gems that are providing similar solutions:
for [Oracle Instant Client][oracle_client_provision] and for [OSX][osx_provision].

In order to install gem add this line to your application's Gemfile:

```bash
gem 'linux_provision'
```

And then execute:

```bash
bundle
```

Before you can start using **linux_provision** gem within your project, you need to configure it. Do the following:

* Create configuration file (e.g. **.linux\_provision.json**) in json format at the root of your project. It will define your environment:

```json
{
  "node": {
   ...
  },

  "project": {
    "home": "#{node.home}/demo",
    "ruby_version": "1.9.3",
    "gemset": "linux_provision_demo"
  },

  "postgres": {
    "hostname": "localhost", "user": "postgres", "password": "postgres",
    "app_user": "pg_user", "app_password": "pg_password",
    "app_schemas": [ "my_project_test", "my_project_dev", "my_project_prod"]
  }
}
```

Variables defined in this file are used by underlying shell scripts provided by the gem.

In **node** section you describe destination computer where you want to install this provision.

In **project** section you keep project-related info, like project **home**, project **gemset name** and **ruby version**.

Last **postgres** section contains information about your postgres server.

* Provide execution script

Library itself if written in ruby, but for launching its code you have to use **rake** or **thor** tool. Here I provide thor script as an example:

```ruby
# thor/linux_install.thor

$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'linux_provision'

class LinuxInstall < Thor
  @installer = LinuxProvision.new self, ".linux_provision.json"

  class << self
    attr_reader :installer
  end

  desc "general", "Installs general packages"
  def general
    invoke :prepare

    invoke :rvm
    invoke :ruby

    invoke :postgres
    invoke :mysql
  end
end
```

You can execute separate commands from script directly with **invoke** thor command. Below is fragment
of such script:

```bash
#!/bin/sh

#######################################
[prepare]
# Updates linux core packages

sudo apt-get update

sudo apt-get install -y curl
sudo apt-get install -y g++
sudo apt-get install -y subversion
sudo apt-get install -y git

#######################################
[rvm]
# Installs rvm

curl -L https://get.rvm.io | bash

#sudo chown -R vagrant /opt/vagrant_ruby

#######################################
[ruby]
# Installs ruby

USER_HOME="#{node.home}"

source $USER_HOME/.rvm/scripts/rvm

rvm install ruby-1.9.3
```

## Demo application with Vagrant


For testing purposes we have created demo web application (in **demo** folder) based on [sinatra][sinatra] framework.

First, we need to inform Vagrant about the location of this application within virtual machine:

```ruby
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.synced_folder "./demo", "/home/vagrant/demo"
end
```

Second, we need to configure linux_provision gem to point to right domain/port and use correct user name/password:

```json
{
  "node": {
    "domain": "22.22.22.22", # remote host, see "config.vm.synced_folder"
    "port": "22",            # default ssh port
    "user": "vagrant",       # vagrant user name
    "password": "vagrant",   #
    "home": "/home/vagrant", # vagrant user password
    "remote": true
  }
}
```

Start your base box:

```bash
vagrant up
```

Access linux box and find out this demo application's home:

```bash
ssh vagrant@22.22.22.22

pwd # /home/vagrant

ls # demo

cd demo

ls # content of demo folder
```

These commands from **linux_provision** gem will build your environment for demo project (install dvm, ruby, postgres, postgres user and tables):

```bash
thor linux_install:prepare
thor linux_install:rvm
thor linux_install:ruby

thor linux_install:postgres

thor linux_install:postgres_create_user
thor linux_install:postgres_create_schemas
```

Initialize demo project and run sinatra application:

```bash
thor linux_install:project

thor linux_install:rackup
```

Now you can access application from your favorite browser:

```bash
open http://22.22.22.22:9292
```

## Demo application with Docker

You need to do very similar steps as with Vagrant. The only difference is in **linux\_provision.json** file you have to point to different host, port and user:

```json
{
  "node": {
    "domain": "192.168.59.103", # remote host, see boot2docker ip
    "port": "42222",            # ssh port in docker
    "user": "vagrant",          # vagrant user name
    "password": "vagrant",      #
    "home": "/home/vagrant",    # vagrant user password
    "remote": true
  }
}
```

Our Dockerfile is responsible for the following base steps:

* Install ubuntu 14.4.

* Install sshd.

* Create vagrant user (just to in-synch with Vagrant example).

* Reveal project home as /home/vagrant/demo.

* Expose port 9292 (our sinatra application).

Here is example:

```txt
FROM ubuntu:14.04

MAINTAINER Alexander Shvets "alexander.shvets@gmail.com"

# 1. Update system
RUN sudo apt-get update
RUN sudo locale-gen en_US.UTF-8

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
RUN sudo chown -R vagrant /home/vagrant

# 4. Prepare directories for the project

# Add project dir to docker

ADD . /home/vagrant/demo
WORKDIR /home/vagrant/demo

EXPOSE 9292
```

Build docker image and run it:

```bash
docker build -t demo demo
docker run -d -p 42222:22 -p 9292:9292 --name demo demo
```

As you can see, we map port 22 inside docker to port 42222 outside. It means that when we hit port 42222 with regular telnet tool, we'll hit service inside the docker.

You can access virtual machine via ssh:

```bash
ssh vagrant@192.168.59.103 -p 42222
ssh root@192.168.59.103 -p 42222
```

Now you can do your provision - it's exactly the same as with Vagrant example:'
'
```bash
thor linux_install:prepare
thor linux_install:rvm
thor linux_install:ruby

thor linux_install:postgres

thor linux_install:postgres_create_user
thor linux_install:postgres_create_schemas

thor linux_install:project

thor linux_install:rackup
```

After provision and starting server try to access your application from the browser:

```bash
open http://192.168.59.103:9292
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[VirtualBox]: https://www.virtualbox.org/wiki/Downloads
[Vagrant]: http://www.vagrantup.com
[boot2docker]: http://boot2docker.io
[oracle_client_provision]:  https://github.com/shvets/oracle_client_provision
[osx_provision]: https://github.com/shvets/osx_provision
[sinatra]: http://www.sinatrarb.com
