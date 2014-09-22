!SLIDE

# Boosting developer's productivity: Using Vagrant and Chef 

* Author: **Alexander Shvets**
* Year: **2014**


!SLIDE title-and-content transition=fade incremental
.notes notes for my slide

# Why do we need virtualization in development?

* We want to have **same environment for all developers**, no matter on what platform they are working now.

* We are **working on multiple projects** on same workstation. As a result, suddenly your computer has "hidden",
hard-to-discover inter-project dependencies or different versions of same library.

* To overcome **It works on my machine!** syndrome - development environment is different from production environment.

* Sometimes required software is **not available** on developer's platform. Example: 64-bit instant client for oracle
was broken for almost two years on OSX >= 10.7.

* **Development for PAAS**, such as Heroku, Engine Yard etc. You can find/build virtualization that is pretty close to
your platform.


!SLIDE content transition=cover

# Vagrant

>

![vagrant](../images/vagrant.jpg)

!SLIDE title-and-content transition=cover

# What is it?

* It is wrapper around virtual box.
* It is an tool for managing virtual machines via a simple to use command line interface.
* With vagrant you can work in a clean environment based on a standard template (base box).



!SLIDE title-and-content transition=cover

# Installation

* Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads). Download it from dedicated web site and install
it as native program. You can use it in UI mode, but it's not required.

* Install [Vagrant](http://www.vagrantup.com). Before it was distributed as ruby gem, now it's done as
native application. Once installed, it will be accessible from command line as **vagrant** command.



!SLIDE title-and-content transition=cover

# Playing with vagrant

* Install linux image

```bash
$ vagrant box add precise64 http://files.vagrantup.com/precise64.box
```

* Initialize

```bash
$ vagrant init precise64
```

* Run or reload

```bash
$ vagrant up
$ vagrant reload
$ vagrant provision
```



!SLIDE title-and-content transition=cover

# Playing with vagrant (continued)

* Suspend/destroy:

```bash
$ vagrant suspend
$ vagrant destroy
```

* or remove linux image

```bash
$ vagrant box remove precise64
```



!SLIDE title-and-content transition=cover

# Access VM

```bash
$ vagrant ssh
```

```bash
vagrant> ls /vagrant
```

* You will see all project's files

```bash
drwxr-xr-x  48 alex  staff   1.6K Apr 21 15:29 ./
drwxrwxrwx  24 alex  staff   816B Apr 21 15:31 ../
-rw-rw-rw-   1 alex  staff   101B Apr 19 10:11 Berksfile
-rw-rw-rw-   1 alex  staff   512B Apr 19 09:57 Berksfile.lock
-rw-rw-rw-   1 alex  staff   188B Apr 17 11:40 Cheffile
-rw-rw-rw-   1 alex  staff   715B Apr 16 11:39 Cheffile.lock
-rw-rw-rw-   1 alex  staff   4.4K Apr 21 14:20 Gemfile
-rw-r--r--   1 alex  staff   9.7K Apr 21 14:20 Gemfile.lock
-rw-r--r--   1 alex  staff   106B Mar 23 13:14 Procfile
-rw-r--r--   1 alex  staff   297B Mar 23 13:14 README.md
-rw-r--r--   1 alex  staff   5.8K Apr 20 11:54 Rakefile
-rw-rw-rw-   1 alex  staff   5.1K Apr 17 15:19 Vagrantfile
drwxr-xr-x   9 alex  staff   306B Mar 24 13:37 app/
-rwxrwxrwx@  1 alex  staff   3.1K Apr 18 09:56 bootstrap.sh*
drwxr-xr-x   8 alex  staff   272B Apr 20 07:54 public/
```



!SLIDE title-and-content transition=cover incremental

# Available provisioners for Vagrant

* Shell
* Chef Server
* Chef Solo
* Puppet Server/Standalone



!SLIDE title-and-content transition=cover

	
# Example 1

* **Vagrantfile** with **bash** shell provisioning:

```ruby
Vagrant::Config.run do |config|
  config.vm.box = "precise64"

  config.vm.network :hostonly, "22.22.22.22"

  config.vm.provision :shell, :path => "bootstrap.sh"
end
```

!SLIDE title-and-content transition=cover

# Example 2

* **Vagrantfile** with **chef** provisioning

```ruby
Vagrant::Config.run do |config|
  config.vm.box = "precise64"
  config.vm.network :hostonly, "22.22.22.22"

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["vendored_cookbooks", "cookbooks"]

    chef.add_recipe 'application'

    chef.json.merge!({
      application: {app_name: "triton"},

      rvm: {ruby: {version: '1.9.3', implementation: 'ruby',
            patch_level: 'p392'}},
      postgresql: { username: "postgres", password: "postgres"},
      mysql: { server_debian_password: "root",
               server_root_password: "root",
               server_repl_password: "root"}
    })
  end
end
```



!SLIDE title-and-content transition=cover

# Example 3

* **Vagrantfile** with multiple environments:

```ruby
Vagrant::Config.run do |config|
  config.vm.define :node1 do |node_config|
    node_config.vm.box = "lucid32"
  end
  config.vm.define :node2 do |node_config|
    node_config.vm.box = "precise32"
  end
end
```

* Start first node in one tab:

```bash
vagrant up node1
vagrant ssh node1
```

* and second node in another tab:

```bash
vagrant up node2
vagrant ssh node2
```


!SLIDE title-and-content transition=cover

# Packaging

* You can create new package based on your vagrant setup.

* This new package can be used by other developers for faster installation.

* It will have already preinstalled and configured ruby/rvm/mysql/postgres etc.:

```bash
vagrant package --vagrantfile Vagrantfile --output new_linux_box.box
```



!SLIDE title-and-content transition=cover

# What's next?

* Once you install Vagrant with some provision (script, chef-solo or puppet), you can use it in same way
as your workstation:

```bash
vagrant ssh

cd /vagrant

rake db:dev:reset

rspec

ASSET_HOST=http://22.22.22.22:3000 rails s
```

* and then access it from the browser within [host computer](http://22.22.22.22:3000/app):

```
  open http://22.22.22.22:3000/app
```


!SLIDE title-and-content incremental commandline transition=cover

# Example of shell script for provisioning:

```bash
# Install core packages

apt-get update
sudo apt-get install -y curl
sudo apt-get install -y g++
sudo apt-get install -y subversion

# Install RVM

\curl -L https://get.rvm.io | bash -s stable --ruby=$RUBY_VERSION
source /usr/local/rvm/scripts/rvm
chown -R vagrant /usr/local/rvm
/usr/local/rvm/bin/rvm autolibs enable

# Install databases

sudo apt-get install -y postgresql-client
sudo apt-get install -y postgresql
sudo apt-get install -y mysql-client
apt-get -y install mysql-server

cd $APP_HOME
bundle install --without=production
rake db:migrate
```



!SLIDE title-and-content transition=cover

# Example of **chef** script for provisioning

```ruby
# cookbooks/application/recipes/default.rb

include_recipe "apt"

package "curl"
package "g++"
package "subversion"

include_recipe "rvm"

bash "Registering RVM" do
  code "source /etc/profile.d/rvm.sh"
  not_if "test -e /usr/local/rvm/bin/rvm"
end

bash "Configuring RVM" do
  user "root"

  code <<-CODE
    chown -R vagrant /usr/local/rvm
    /usr/local/rvm/bin/rvm autolibs enable
  CODE
end
include_recipe "rvm::install"
```



!SLIDE title-and-content transition=cover

# Example of **chef** script for provisioning (continued)

```ruby
include_recipe "postgresql"
include_recipe "postgresql::server"
include_recipe "mysql"
include_recipe "mysql::server"

bash "Installing bundle" do
  user 'vagrant'
  cwd app_home

  code <<-CODE
source /etc/profile.d/rvm.sh
rvm use #{ruby_version}@#{gem_name} --create
bundle install --without=production
 CODE
end

bash "Project db bootstrap" do
  user 'vagrant'
  cwd app_home

  code <<-CODE
    source /etc/profile.d/rvm.sh
    rake db:migrate
  CODE
end
```
