#!/bin/sh

/etc/init.d/postgresql start

psql --command "CREATE USER ruby_dev WITH SUPERUSER PASSWORD 'ruby_dev';"

createdb -O ruby_dev ruby_dev_test
createdb -O ruby_dev ruby_dev_dev
createdb -O ruby_dev ruby_dev_prod

psql -l

/etc/init.d/postgresql stop

