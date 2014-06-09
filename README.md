# Linux Provision

Library and thor tasks for provisioning of Linux computer initial setup for Ruby/Rails development


# $ vagrant box add precise64 http://files.vagrantup.com/precise64.box
# $ vagrant init precise64
# $ vagrant up
# $ vagrant reload
# $ vagrant provision
# $ vagrant suspend
# $ vagrant halt
# $ vagrant destroy
# $ vagrant box remove precise64
#
# $ vagrant ssh
# $ ssh vagrant@127.0.0.1 -p 2222

# ```bash
# vagrant ssh
#
# cd /vagrant
#
# rake db:dev:reset
#
# rspec
#
# ASSET_HOST=http://22.22.22.22:3000 rails s
# ```
#
# * and then access it from the browser within [host computer](http://22.22.22.22:3000/app):
#
#     ```
#   open http://22.22.22.22:3000/app
# ```

# $ vagrant package --vagrantfile Vagrantfile --output linux_provision.box

