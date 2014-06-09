$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'linux_provision/linux_provision'

class LinuxInstall < Thor
  attr_reader :installer

  def initialize *params
    @installer = LinuxProvision.new

    super *params
  end

  desc "test", "test"
  def test
    installer.test
  end

  desc "all", "Installs all required packages"
  def all
    invoke :prepare

    invoke :rvm

    invoke :ruby

    invoke :git
    invoke :node
    invoke :jenkins
    invoke :postgres
    invoke :mysql

    invoke :postgres_create_user
    invoke :postgres_create_schemas

    invoke :mysql_create_user
    invoke :mysql_create_schemas

    # invoke :selenium
  end

  desc "postgres_create", "Initializes postgres"
  def postgres_create
    invoke :postgres_create_user
    invoke :postgres_create_schemas
  end

  desc "postgres_drop", "Drops postgres project schemas"
  def postgres_drop
    installer.postgres_drop env["app_user"], env["app_schemas"]
  end

  desc "mysql_create", "Initializes mysql"
  def mysql_create
    invoke :mysql_create_user
    invoke :mysql_create_schemas
  end

  private

  def method_missing(method, *args, &block)
    installer.send(method, *args, &block)
  end

  # desc "prepare", "prepare"
  # def prepare
  #   installer.prepare
  # end

  # desc "rvm", "Installs rvm"
  # def rvm
  #   installer.rvm_install
  # end

  # desc "npm", "Installs npm"
  # def npm
  #   installer.npm_install
  # end

  # desc "qt", "Installs qt"
  # def qt
  #   installer.qt_install
  # end

  # desc "mysql", "Installs mysql server"
  # def mysql
  #   installer.mysql_install
  # end

  # desc "mysql_restart", "Restarts mysql server"
  # def mysql_restart
  #   installer.mysql_restart
  # end
  #
  # desc "postgres", "Installs postgres server"
  # def postgres
  #   installer.postgres_install
  # end
  #
  # desc "postgres_restart", "Restarts postgres server"
  # def postgres_restart
  #   installer.postgres_restart
  # end
  #
  # desc "postgres_stop", "Stop postgres server"
  # def postgres_stop
  #   installer.postgres_stop
  # end
  #
  # desc "postgres_start", "Start postgres server"
  # def postgres_start
  #   installer.postgres_start
  # end
  #
  # desc "ruby", "Installs ruby"
  # def ruby
  #   installer.ruby_install
  # end
  #
  # desc "jenkins", "Installs jenkins server"
  # def jenkins
  #   installer.jenkins_install
  # end
  #
  # desc "jenkins_restart", "Restart jenkins server"
  # def jenkins_restart
  #   installer.jenkins_restart
  # end
  #
  # desc "selenium", "Installs selenium server"
  # def selenium
  #   installer.selenium_install
  # end
  #
  # desc "selenium_restart", "Restarts selenium server"
  # def selenium_restart
  #   installer.selenium_restart
  # end

  #
  # desc "postgres_test", "Test postgres schemas"
  # def postgres_test
  #   installer.postgres_test env["app_user"]
  # end
  #

end
