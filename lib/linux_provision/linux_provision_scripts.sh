#!/bin/sh

[test]
# Test

echo "test"


##############################
[prepare]

sudo apt-get update

sudo apt-get install -y curl
sudo apt-get install -y g++
sudo apt-get install -y subversion


##############################
[rvm]
#PATH=$PATH:/usr/local/bin

USER_HOME="#{node.home}"

curl -L https://get.rvm.io | bash

sudo chown -R vagrant /opt/vagrant_ruby

source $USER_HOME/.rvm/scripts/rvm


##############################
[ruby]

source $USER_HOME/.rvm/scripts/rvm

rvm install ruby-1.9.3


##############################
[git]

sudo apt-get install -y  git


##############################
[node]

sudo apt-get install -y node


##############################
[jenkins]
sudo apt-get install -y jenkins


##############################
[postgres]

sudo apt-get install -y postgresql-client
sudo apt-get install -y libpq-dev
sudo apt-get install -y postgresql


##############################
[mysql]

MYSQL_PASSWORD='#{mysql.password}'

MYSQL_SERVER_VERSION='5.5'

sudo apt-get install -y libmysqlclient-dev ruby-dev

sudo apt-get install debconf-utils
sudo apt-get install -y mysql-client

sudo debconf-set-selections <<< "mysql-server-$MYSQL_SERVER_VERSION mysql-server/root_password password $MYSQL_PASSWORD"
sudo debconf-set-selections <<< "mysql-server-$MYSQL_SERVER_VERSION mysql-server/root_password_again password $MYSQL_PASSWORD"

sudo apt-get -y install mysql-server


##############################
[postgres_create_user]

PATH=$PATH:/usr/local/bin

APP_USER='#{postgres.app_user}'

sudo -u postgres psql -c "CREATE USER $APP_USER WITH PASSWORD '$APP_USER'"
#createuser -s -d -r $APP_USER

##############################
[postgres_drop_user]

##############################
[postgres_create_schema]

SCHEMA='#{schema}'

POSTGRES_USER='#{postgres.user}'
APP_USER='#{postgres.app_user}'

ENCODING_STRING="WITH ENCODING = 'UTF-8' LC_CTYPE = 'en_US.utf8' LC_COLLATE = 'en_US.utf8' OWNER $POSTGRES_USER TEMPLATE template0"

sudo -u postgres psql -c "CREATE DATABASE $SCHEMA $ENCODING_STRING"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $SCHEMA to $APP_USER"
#createdb -U $APP_USER $SCHEMA


##############################
[postgres_drop_schema]


##############################
[mysql_create_user]

APP_USER='#{mysql.app_user}'
HOST_NAME='#{mysql.hostname}'

MYSQL_USER='#{mysql.user}'
MYSQL_PASSWORD='#{mysql.password}'

mysql -h $HOST_NAME -u root -p"root" -e "grant all privileges on *.* to '$APP_USER'@'$HOST_NAME' identified by '$APP_USER' with grant option;"
mysql -h localhost -u $MYSQL_USER -p"$MYSQL_PASSWORD" -e "grant all privileges on *.* to '$APP_USER'@'%' identified by '$APP_USER' with grant option;"
mysql -h localhost -u $MYSQL_USER -p"$MYSQL_PASSWORD" -e "CREATE USER '$APP_USER'@'localhost' IDENTIFIED BY '$APP_USER';"


##############################
[mysql_drop_user]

APP_USER='#{mysql.app_user}'
HOST_NAME='#{mysql.hostname}'

MYSQL_USER='#{mysql.user}'
MYSQL_PASSWORD='#{mysql.password}'

mysql -h $HOST_NAME  -u $MYSQL_USER -p"$MYSQL_PASSWORD" -e "DROP USER '$APP_USER'@'$HOST_NAME';"


##############################
[mysql_create_schema]

SCHEMA='#{schema}'

HOST_NAME='#{mysql.hostname}'

MYSQL_USER='#{mysql.user}'
MYSQL_PASSWORD='#{mysql.password}'

mysql -h $HOST_NAME -u $MYSQL_USER -p"$MYSQL_PASSWORD" -e "create database $SCHEMA;"


##############################
[mysql_drop_schema]


##############################
[project]

APP_HOME='$USER_HOME/linux_provision'

cd $APP_HOME

source $USER_HOME/.rvm/scripts/rvm

rvm use 1.9.3@linux_provision

bundle install --without=production

# rake db:migrate
# rails s
