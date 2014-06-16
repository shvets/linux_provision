#!/bin/bash

cd /opt/demo

source /etc/profile.d/rvm.sh

bundle exec rackup
