#!/bin/sh

##############################
[project]
# Installs demo sinatra project

USER_HOME="#{node.home}"

APP_HOME="#{project.home}"

cd $APP_HOME

source $USER_HOME/.rvm/scripts/rvm

rvm use #{project.ruby_version}@#{project.gemset} --create

bundle

rake db:migrate


##############################
[rackup]
# Starts sinatra demo application

USER_HOME="#{node.home}"

APP_HOME="#{project.home}"

cd $APP_HOME

source $USER_HOME/.rvm/scripts/rvm

rackup
