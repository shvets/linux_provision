#!/bin/sh

[test]
# Test

echo "test"


##############################
[prepare]
# Updates linux core packages

sudo apt-get update

sudo apt-get install -y curl
sudo apt-get install -y g++
sudo apt-get install -y subversion
sudo apt-get install -y git


##############################
[rvm]
# Installs rvm

curl -L https://get.rvm.io | bash

sudo chown -R vagrant /opt/vagrant_ruby


##############################
[ruby]
# Installs ruby

USER_HOME="#{node.home}"

source $USER_HOME/.rvm/scripts/rvm

rvm install ruby-1.9.3


##############################
[node]
# Installs node

sudo apt-get install -y node


##############################
[jenkins]
# Installs jenkins

sudo apt-get install -y jenkins


##############################
[postgres]
# Installs postgres server

sudo apt-get install -y postgresql-client
sudo apt-get install -y libpq-dev
sudo apt-get install -y postgresql


##############################
[mysql]
# Installs mysql server

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
APP_PASSWORD='#{postgres.app_password}'

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
# http://www.labelmedia.co.uk/blog/setting-up-selenium-server-on-a-headless-jenkins-ci-build-machine.html
[selenium]
# Installs selenium server

wget http://selenium-release.storage.googleapis.com/2.42/selenium-server-standalone-2.42.2.jar

sudo mkdir /var/lib/selenium

sudo mv selenium-server-standalone-2.42.2.jar /var/lib/selenium

cd /var/lib/selenium

sudo ln -s selenium-server-standalone-2.42.2.jar selenium-server.jar

sudo apt-get install -y xvfb
sudo update-rc.d xvfb defaults 10

sudo apt-get install -y firefox

# export DISPLAY=":99" && java -jar /var/lib/selenium/selenium-server.jar


##############################
[selenium2]
cat > xvfb <<END
#!/bin/bash

if [ -z "$1" ]; then
  echo "`basename $0` {start|stop}"
  exit
fi

case "$1" in
  start)
    /usr/bin/Xvfb :99 -ac -screen 0 1024x768x8 &
    ;;

  stop)
    killall Xvfb
    ;;
esac
END

#sudo mv xvfb /etc/init.d/xvfb

#sudo chmod 755 /etc/init.d/xvfb

/etc/init.d/xvfb start

