#!/bin/sh

##############################
[project]

USER_HOME="#{node.home}"

APP_HOME="#{project.home}"

cd $APP_HOME

source $USER_HOME/.rvm/scripts/rvm

rvm use #{project.ruby_version}@#{project.gemset}

bundle install --without=production

rake db:migrate


##############################
[rackup]

USER_HOME="#{node.home}"

APP_HOME="#{project.home}"

cd $APP_HOME

source $USER_HOME/.rvm/scripts/rvm

rackup