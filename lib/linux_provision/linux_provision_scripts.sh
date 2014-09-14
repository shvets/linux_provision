#!/bin/sh

#######################################
[prepare]
# Updates linux core packages

sudo apt-get update

sudo apt-get install -y curl
sudo apt-get install -y g++
sudo apt-get install -y subversion
sudo apt-get install -y git

# to support rvm

sudo apt-get install -y libyaml-dev
sudo apt-get install -y libsqlite3-dev
sudo apt-get install -y sqlite3
sudo apt-get install -y autoconf
sudo apt-get install -y libgdbm-dev
sudo apt-get install -y libncurses5-dev
sudo apt-get install -y automake
sudo apt-get install -y bison
sudo apt-get install -y pkg-config
sudo apt-get install -y libffi-dev
sudo apt-get install -y libreadline6-dev
sudo apt-get install -y zlib1g-dev
sudo apt-get install -y libssl-dev
sudo apt-get install -y libtool

#######################################
[rvm]
# Installs rvm

curl -L https://get.rvm.io | bash

#sudo chown -R vagrant /opt/vagrant_ruby


#######################################
[ruby]
# Installs ruby

USER_HOME="#{node.home}"

source $USER_HOME/.rvm/scripts/rvm

rvm install ruby-1.9.3


#######################################
[node]
# Installs node

sudo apt-get install -y node


#######################################
[jenkins]
# Installs jenkins

sudo apt-get install -y jenkins


#######################################
[postgres]
# Installs postgres server

sudo apt-get install -y postgresql-client
sudo apt-get install -y libpq-dev
sudo apt-get install -y postgresql

sudo service postgresql restart

#######################################
[postgres_remote_access]

sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/9.1/main/postgresql.conf
sudo sed -i '$a host all all  0.0.0.0/0 md5' /etc/postgresql/9.1/main/pg_hba.conf

#######################################
[postgres_create_user]
# Creates postgres user

PATH=$PATH:/usr/local/bin

APP_USER='#{postgres.app_user}'
APP_PASSWORD='#{postgres.app_password}'

sudo -u postgres psql -c "CREATE USER $APP_USER WITH PASSWORD '$APP_USER'"


#######################################
[postgres_drop_user]
# Drops postgres user

PATH=$PATH:/usr/local/bin

APP_USER='#{postgres.app_user}'

sudo -u postgres psql -c "DROP USER $APP_USER"


#######################################
[postgres_create_schema]
# Creates postgres schema

SCHEMA='#{schema}'

POSTGRES_USER='#{postgres.user}'
APP_USER='#{postgres.app_user}'

ENCODING_STRING="WITH ENCODING = 'UTF-8' LC_CTYPE = 'en_US.utf8' LC_COLLATE = 'en_US.utf8' OWNER $POSTGRES_USER TEMPLATE template0"

sudo -u postgres psql -c "CREATE DATABASE $SCHEMA $ENCODING_STRING"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $SCHEMA to $APP_USER"


#######################################
[postgres_drop_schema]
# Drops postgres schema

PATH=$PATH:/usr/local/bin

SCHEMA='#{schema}'

sudo -u postgres psql -c "DROP DATABASE $SCHEMA"

#######################################
[mysql]
# Installs mysql server

PATH=$PATH:/usr/local/bin

MYSQL_USER='#{mysql.user}'
MYSQL_PASSWORD='#{mysql.password}'
MYSQL_SERVER_VERSION='5.5'

sudo apt-get install -y libmysqlclient-dev ruby-dev

sudo apt-get install debconf-utils
sudo apt-get install -y mysql-client

sudo debconf-set-selections <<< "mysql-server-$MYSQL_SERVER_VERSION mysql-server/root_password password $MYSQL_PASSWORD"
sudo debconf-set-selections <<< "mysql-server-$MYSQL_SERVER_VERSION mysql-server/root_password_again password $MYSQL_PASSWORD"

sudo apt-get -y install mysql-server

sudo service mysql restart

#sudo mysqladmin -u$MYSQL_USER password $MYSQL_PASSWORD


#######################################
[mysql_create_user]
# Creates mysql user

PATH=$PATH:/usr/local/bin

HOST_NAME='#{mysql.hostname}'
APP_USER='#{mysql.app_user}'
MYSQL_USER='#{mysql.user}'
MYSQL_PASSWORD='#{mysql.password}'

mysql -h $HOST_NAME -u$MYSQL_USER -p$MYSQL_PASSWORD -e "CREATE USER '$APP_USER'@'$HOST_NAME' IDENTIFIED BY '$APP_USER';"
mysql -h $HOST_NAME -u$MYSQL_USER -p$MYSQL_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* to '$APP_USER'@'$HOST_NAME' IDENTIFIED BY '$APP_USER' WITH GRANT OPTION;"


#######################################
[mysql_drop_user]
# Drops mysql user

APP_USER='#{mysql.app_user}'
HOST_NAME='#{mysql.hostname}'

MYSQL_USER='#{mysql.user}'
MYSQL_PASSWORD='#{mysql.password}'

mysql -h $HOST_NAME  -u $MYSQL_USER -p"$MYSQL_PASSWORD" -e "DROP USER '$APP_USER'@'$HOST_NAME';"


#######################################
[mysql_create_schema]
# Creates mysql schema

PATH=$PATH:/usr/local/bin

SCHEMA='#{schema}'

HOST_NAME='#{mysql.hostname}'
MYSQL_USER='#{mysql.user}'
MYSQL_PASSWORD='#{mysql.password}'

mysql -h $HOST_NAME -u$MYSQL_USER -p$MYSQL_PASSWORD -e "create database $SCHEMA;"


#######################################
[mysql_drop_schema]
# Drops mysql schema

PATH=$PATH:/usr/local/bin

SCHEMA='#{schema}'

HOST_NAME='#{mysql.hostname}'
MYSQL_USER='#{mysql.user}'
MYSQL_PASSWORD='#{mysql.password}'

mysql -h $HOST_NAME -u$MYSQL_USER -p$MYSQL_PASSWORD -e "drop database $SCHEMA;"


#######################################
[service_command]

SERVICE='#{service}'
COMMAND='#{command}'

sudo service $SERVICE $COMMAND


#######################################
[selenium_prepare]

sudo apt-get install -y xvfb

sudo apt-get install -y x11-xkb-utils xfonts-100dpi xfonts-75dpi
sudo apt-get install -y xfonts-scalable xserver-xorg-core
sudo apt-get install -y dbus-x11
sudo apt-get install -y libfontconfig1-dev

sudo apt-get install -y firefox
sudo apt-get install -y chromium-browser

sudo apt-get install -y default-jdk

#######################################
[selenium]
# http://www.labelmedia.co.uk/blog/setting-up-selenium-server-on-a-headless-jenkins-ci-build-machine.html
# https://www.exratione.com/2013/12/angularjs-headless-end-to-end-testing-with-protractor-and-selenium/
# Installs selenium server

sudo /usr/sbin/useradd -m -s /bin/bash -d /home/selenium selenium
echo 'selenium:selenium' |chpasswd

wget http://selenium-release.storage.googleapis.com/2.42/selenium-server-standalone-2.42.2.jar

sudo mkdir /var/lib/selenium

sudo mv selenium-server-standalone-2.42.2.jar /var/lib/selenium

sudo chown -R selenium:selenium /var/lib/selenium

sudo mkdir /var/log/selenium
sudo chown selenium:selenium /var/log/selenium

cd /var/lib/selenium

sudo ln -s selenium-server-standalone-2.42.2.jar selenium-server.jar

cd

cat > selenium-standalone << END
#!/bin/bash
#
# Selenium standalone server init script.
#
# For Debian-based distros.
#
### BEGIN INIT INFO
# Provides:          selenium-standalone
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Selenium standalone server
### END INIT INFO

DESC="Selenium standalone server"
USER=selenium
JAVA=/usr/bin/java
PID_FILE=/var/run/selenium.pid
JAR_FILE=/usr/local/share/selenium/selenium-server-standalone-2.42.2.jar
LOG_FILE=/var/log/selenium/selenium.log

DAEMON_OPTS="-Xmx500m -Xss1024k -jar $JAR_FILE -log $LOG_FILE"
# See this Stack Overflow item for a delightful bug in Java that requires the
# strange-looking java.security.egd workaround below:
# http://stackoverflow.com/questions/14058111/selenium-server-doesnt-bind-to-socket-after-being-killed-with-sigterm
DAEMON_OPTS="-Djava.security.egd=file:/dev/./urandom $DAEMON_OPTS"

# The value for DISPLAY must match that used by the running instance of Xvfb.
export DISPLAY=:10

# Make sure that the PATH includes the location of the ChromeDriver binary.
# This is necessary for tests with Chromium to work.
export PATH=$PATH:/usr/local/bin

case "$1" in
    start)
        echo "Starting $DESC: "
        start-stop-daemon -c $USER --start --background \
            --pidfile $PID_FILE --make-pidfile --exec $JAVA -- $DAEMON_OPTS
        ;;

    stop)
        echo  "Stopping $DESC: "
        start-stop-daemon --stop --pidfile $PID_FILE
        ;;

    restart)
        echo "Restarting $DESC: "
        start-stop-daemon --stop --pidfile $PID_FILE
        sleep 1
        start-stop-daemon -c $USER --start --background \
            --pidfile $PID_FILE  --make-pidfile --exec $JAVA -- $DAEMON_OPTS
        ;;

    *)
        echo "Usage: /etc/init.d/selenium-standalone {start|stop|restart}"
        exit 1
    ;;
esac

exit 0
END

sudo mv selenium-standalone /etc/init.d/selenium-standalone

sudo chown root:root /etc/init.d/selenium-standalone
sudo chmod a+x /etc/init.d/selenium-standalone
sudo update-rc.d selenium-standalone defaults

sudo /etc/init.d/selenium-standalone restart

#######################################
[selenium2]
cat > xvfb << END
#!/bin/bash
#
# Xvfb init script for Debian-based distros.
#
# The display number used must match the DISPLAY environment variable used
# for other applications that will use Xvfb. e.g. ':10'.
#
# From: https://github.com/gmonfort/xvfb-init/blob/master/Xvfb
#
### BEGIN INIT INFO
# Provides:          xvfb
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start/stop custom Xvfb
# Description:       Enable service provided by xvfb
### END INIT INFO

NAME=Xvfb
DESC="$NAME - X Virtual Frame Buffer"
SCRIPTNAME=/etc/init.d/$NAME
XVFB=/usr/bin/Xvfb
PIDFILE=/var/run/${NAME}.pid

# Using -extension RANDR doesn't seem to work anymore. Firefox complains
# about not finding extension RANDR whether or not you include it here.
# Fortunately this is a non-fatal warning and doesn't stop Firefox from working.
XVFB_ARGS=":10 -extension RANDR -noreset -ac -screen 10 1024x768x16"

set -e

if [ `id -u` -ne 0 ]; then
  echo "You need root privileges to run this script"
  exit 1
fi

[ -x $XVFB ] || exit 0

. /lib/lsb/init-functions

[ -r /etc/default/Xvfb ] && . /etc/default/Xvfb

case "$1" in
  start)
    log_daemon_msg "Starting $DESC" "$NAME"
    if start-stop-daemon --start --quiet --oknodo --pidfile $PIDFILE \
          --background --make-pidfile --exec $XVFB -- $XVFB_ARGS ; then
      log_end_msg 0
    else
      log_end_msg 1
    fi
    log_end_msg $?
    ;;

  stop)
    log_daemon_msg "Stopping $DESC" "$NAME"
    start-stop-daemon --stop --quiet --oknodo --pidfile $PIDFILE --retry 5
    if [ $? -eq 0 ] && [ -f $PIDFILE ]; then
      /bin/rm -rf $PIDFILE
    fi
    log_end_msg $?
    ;;

  restart|force-reload)
    log_daemon_msg "Restarting $DESC" "$NAME"
    $0 stop && sleep 2 && $0 start
    ;;

  status)
    status_of_proc -p $PIDFILE $XVFB $NAME && exit 0 || exit $?
    ;;

  *)
    log_action_msg "Usage: ${SCRIPTNAME} {start|stop|status|restart|force-reload}"
    exit 2
    ;;
esac
exit 0
END

sudo mv xvfb /etc/init.d/xvfb

sudo chown root:root /etc/init.d/xvfb
sudo chmod a+x /etc/init.d/xvfb
sudo update-rc.d xvfb defaults

sudo /etc/init.d/xvfb restart

# export DISPLAY=":99" && java -jar /var/lib/selenium/selenium-server.jar


