# Linux Provision

## Library and thor tasks for provisioning of Linux computer initial setup for Ruby/Rails development


# Introduction

Why do we need virtualization in development?

* We want to have **same environment for all developers**, no matter on what platform they are working now.

* We are **working on multiple projects** on same workstation. As a result, suddenly your computer has "hidden",
hard-to-discover inter-project dependencies or different versions of same library.

* To overcome **It works on my machine!** syndrome - development environment is different from production environment.

* Sometimes required software is **not available** on developer's platform. Example: 64-bit instant client for oracle
was broken for almost two years on OSX >= 10.7.

* **Development for PAAS**, such as Heroku, Engine Yard etc. You can find/build virtualization that is pretty close to
your platform.

We will take a look at how can we do provisioning with Vagrant and Docker.

# Vagrant

First, you need to decide what linux installation you need, install linux image (base box) and then
initialize it:

```bash
vagrant box add ubuntu/trusty64 https://vagrantcloud.com/ubuntu/boxes/trusty64

vagrant init ubuntu/trusty64
```

Last **init** command will create Vagrantfile file.

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
end
```

Various vagrant commands:

```bash
vagrant up        # starts up: creates and configures guest machines
vagrant suspend   # suspends the guest machine
vagrant halt      # shuts down the running machine
vagrant reload    # halt; up
vagrant destroy   # stops the running machine and destroys all related resources

vagrant provision # perform provisioning configured for machine

vagrant box remove ubuntu/trusty64 # removes a box from vagrant

# packages a currently running VirtualBox environment into a re-usable box.
vagrant package --vagrantfile Vagrantfile --output linux_provision.box
```

Now, start your vagrant:

```bash
vagrant up
```

At this moments, you have a fully running virtual machine in VirtualBox running Ubuntu 14.04 LTS 64-bit.

You can SSH into this machine with vagrant ssh:

```bash
vagrant ssh
```

or directly with ssh (use "vagrant" password for "vagrant" user and port 2222):

```bash
ssh vagrant@127.0.0.1 -p 2222
```

You can assign special IP address for your linux box:

```ruby
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.network "private_network", ip: "22.22.22.22"
end
```

With this configuration you can access ssh on default port:

```bash
ssh vagrant@22.22.22.22
```

For testing purposes we have created demo web application (in **demo** folder) based on sinatra framework.
We need to mount this application:

```ruby
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.synced_folder "./demo", "/home/vagrant/demo"
end
```

Access linux box and find out this demo application:

```bash
ssh vagrant@22.22.22.22

pwd # /home/vagrant

ls # demo

cd demo

ls # content of demo folder
```

Your linux box initial setup is ready to use. Now we treat it as remote box and try to install
our provision into it. You can use standard provisioning that comes with vagrant, but it's not
flexible enough. Instead, we have set of scripts that can be executed remotely. Look into
.linux\_provision for configuration:

```json
{
  "node": {
    "domain": "22.22.22.22",
    "port": "22",
    "user": "vagrant",
    "password": "vagrant",
    "home": "/home/vagrant",
    "remote": true
  },

  "project": {
    "home": "#{node.home}/demo",
    "ruby_version": "1.9.3",
    "gemset": "linux_provision_demo"
  },

  "postgres": {
    "hostname": "localhost", "user": "postgres", "password": "postgres",
    "app_user": "ruby_dev", "app_password": "ruby_dev",
    "app_schemas": ["ruby_dev_test", "ruby_dev_dev", "ruby_dev_prod"]
  }
}
```

In **node** section we describe location and credentials of our virtual box. In **postgres**
section we define what postgres user and schemas need to be created.

Run these commands:

```bash
thor linux_install:prepare
thor linux_install:rvm
thor linux_install:ruby

thor linux_install:postgres

thor linux_install:postgres_create_user
thor linux_install:postgres_create_schemas
```

and new environment for demo project will be created.

Initialize demo project and run sinatra application:

```bash
thor linux_install:project

thor linux_install:rackup
```

Now you can access application from your favorite browser:

```bash
open http://22.22.22.22:9292
```



## Docker


docker is an open-source project that makes creating and managing Linux containers really easy. 
Containers are like extremely lightweight VMs – they allow code to run in isolation from other containers 
but safely share the machine’s resources, all without the overhead of a hypervisor.

docker containers can boot extremely fast (in milliseconds!) which gives you unprecedented flexibility 
in managing load across your cluster. For example, instead of running chef on each of your VMs, 
it’s faster and more reliable to have your build system create a container and launch it on 
the appropriate number of CoreOS hosts. When these containers start, they can signal your proxy (via etcd) 
to start sending them traffic.


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
docker build -t demo docker/demo
```

```bash
docker run -p 49160:8080 -d busybox
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
