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

USER_HOME="#{home}"

curl -L https://get.rvm.io | bash

sudo chown -R vagrant /opt/vagrant_ruby

source $USER_HOME/.rvm/scripts/rvm


#######################################
[node]

sudo apt-get install -y node


##############################
[ruby]

source /home/vagrant/.rvm/scripts/rvm

rvm install ruby-1.9.3


##############################
[git]

sudo apt-get install -y  git


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

MYSQL_PASSWORD='root'

MYSQL_SERVER_VERSION='5.5'

sudo apt-get install -y libmysqlclient-dev ruby-dev

sudo apt-get install debconf-utils
sudo apt-get install -y mysql-client

sudo debconf-set-selections <<< "mysql-server-$MYSQL_SERVER_VERSION mysql-server/root_password password $MYSQL_PASSWORD"
sudo debconf-set-selections <<< "mysql-server-$MYSQL_SERVER_VERSION mysql-server/root_password_again password $MYSQL_PASSWORD"

sudo apt-get -y install mysql-server


#######################################
[create_postgres_user]

PATH=$PATH:/usr/local/bin

APP_USER='#{app_user}'

createuser -s -d -r $APP_USER

sudo -u postgres psql -c "CREATE USER $APP_USER WITH PASSWORD '$APP_USER'"


#######################################
[create_postgres_schema]
TEST_DB_SCHEMA='ruby_dev_test'
DEV_DB_SCHEMA='ruby_dev_dev'
PROD_DB_SCHEMA='ruby_dev_prod'

APP_USER='ruby_dev'
SCHEMA='#{postgres.app_schemas[0]}'

createdb -U $APP_USER $SCHEMA
sudo -u postgres psql -c "CREATE USER $APP_USER WITH PASSWORD '$APP_USER'"

##############################
[postgres_db]

POSTGRES_USER='postgres'
POSTGRES_PASSWORD='postgres'

APP_USER='ruby_dev'

TEST_DB_SCHEMA='ruby_dev_test'
DEV_DB_SCHEMA='ruby_dev_dev'
PROD_DB_SCHEMA='ruby_dev_prod'

sudo usermod --password $POSTGRES_USER $POSTGRES_PASSWORD

sudo -u postgres psql -c "CREATE USER $APP_USER WITH PASSWORD '$APP_USER'"

ENCODING_STRING="WITH ENCODING = 'UTF-8' LC_CTYPE = 'en_US.utf8' LC_COLLATE = 'en_US.utf8' OWNER $POSTGRES_USER TEMPLATE template0"

sudo -u postgres psql -c "CREATE DATABASE $DEV_DB_SCHEMA $ENCODING_STRING"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DEV_DB_SCHEMA to $APP_USER"

sudo -u postgres psql -c "CREATE DATABASE $TEST_DB_SCHEMA $ENCODING_STRING"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $TEST_DB_SCHEMA to $APP_USER"

sudo -u postgres psql -c "CREATE DATABASE $PROD_DB_SCHEMA $ENCODING_STRING"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $PROD_DB_SCHEMA to $APP_USER"


#######################################
[create_mysql_user]

#PATH=$PATH:/usr/local/bin

APP_USER='#{app_user}'
HOST_NAME='#{mysql[:hostname]}'
USER='#{mysql[:user]}'
PASSWORD='#{mysql][:password]}'

mysql -h $HOST_NAME -u root -p"root" -e "DROP USER '$APP_USER'@'$HOST_NAME';"
mysql -h $HOST_NAME -u root -p"root" -e "CREATE USER '$APP_USER'@'$HOST_NAME' IDENTIFIED BY '$APP_USER';"

mysql -h $HOST_NAME -u root -p"root" -e "grant all privileges on *.* to '$APP_USER'@'$HOST_NAME' identified by '$APP_USER' with grant option;"
mysql -h $HOST_NAME -u root -p"root" -e "grant all privileges on *.* to '$APP_USER'@'%' identified by '$APP_USER' with grant option;"


#######################################
[create_mysql_schema]

PATH=$PATH:/usr/local/bin

SCHEMA='#{schema}'
HOST_NAME='#{mysql[:hostname]}'
USER='#{mysql[:user]}'
PASSWORD='#{mysql[:password]}'

mysql -h $HOST_NAME -u root -p"root" -e "create database $SCHEMA;"

##############################
[mysql_db]

MYSQL_USER='root'
MYSQL_PASSWORD='root'

APP_USER='ruby_dev'

TEST_DB_SCHEMA='ruby_dev_test'
DEV_DB_SCHEMA='ruby_dev_dev'
PROD_DB_SCHEMA='ruby_dev_prod'

mysql -h localhost -u $MYSQL_USER -p"$MYSQL_PASSWORD" -e "CREATE USER '$APP_USER'@'localhost' IDENTIFIED BY '$APP_USER';"

mysql -h localhost -u $MYSQL_USER -p"$MYSQL_PASSWORD" -e "grant all privileges on *.* to '$APP_USER'@'localhost' identified by '$APP_USER' with grant option;"
mysql -h localhost -u $MYSQL_USER -p"$MYSQL_PASSWORD" -e "grant all privileges on *.* to '$APP_USER'@'%' identified by '$APP_USER' with grant option;"

mysql -h localhost -u $MYSQL_USER -p"$MYSQL_PASSWORD" -e "create database $TEST_DB_SCHEMA;"
mysql -h localhost -u $MYSQL_USER -p"$MYSQL_PASSWORD" -e "create database $DEV_DB_SCHEMA;"
mysql -h localhost -u $MYSQL_USER -p"$MYSQL_PASSWORD" -e "create database $PROD_DB_SCHEMA;"


[project]

APP_HOME='/home/vagrant/linux_provision'

cd $APP_HOME

source /home/vagrant/.rvm/scripts/rvm

rvm use 1.9.3@linux_provision

bundle install --without=production

# rake db:migrate
# rails s
