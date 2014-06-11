# Linux Provision

## Library and thor tasks for provisioning of Linux computer initial setup for Ruby/Rails development

```bash
vagrant box add precise64 http://files.vagrantup.com/precise64.box
vagrant init precise64

vagrant up
vagrant reload
vagrant provision

vagrant suspend
vagrant halt
vagrant destroy
vagrant box remove precise64

vagrant ssh

ssh vagrant@127.0.0.1 -p 2222

vagrant ssh

cd /vagrant

rake db:dev:reset

rspec

ASSET_HOST=http://22.22.22.22:3000 rails s
```

and then access it from the browser within [host computer](http://22.22.22.22:3000/app):

```bash
open http://22.22.22.22:3000/app
```

```bash
vagrant package --vagrantfile Vagrantfile --output linux_provision.box
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

brew install docker
```

Initialize boot2docker virtual machine:

```bash
boot2docker init
```

Start the docker daemon:

```bash
export DOCKER_HOST=tcp://127.0.0.1:4243

boot2docker up
```

or down:

```bash
boot2docker down
```

or ssh:

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

Run:

```bash
docker run ubuntu /bin/echo hello world
docker run -t -i ubuntu /bin/bash
```

```bash
docker build -t ashvets/centos-node-hello .
```



docker run -p 49160:8080 -d busybox


## Links

http://www.talkingquickly.co.uk/2014/06/rails-development-environment-with-vagrant-and-docker/   
https://github.com/TalkingQuickly/docker_rails_dev_env/

https://coreos.com/docs/launching-containers/building/getting-started-with-docker/
http://docs.docker.io/installation/binaries/#dockergroup