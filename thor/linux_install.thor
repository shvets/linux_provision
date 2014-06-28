$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'linux_provision/linux_provision'

class LinuxInstall < Thor
  @installer = LinuxProvision.new self, ".linux_provision.json", [File.expand_path("demo_scripts.sh", File.dirname(__FILE__))]

  class << self
    attr_reader :installer
  end

  desc "general", "Installs general packages"
  def general
    invoke :prepare

    invoke :rvm
    invoke :ruby

    invoke :postgres
    invoke :mysql
  end

  desc "special", "Installs special packages"
  def special
    invoke :node
    invoke :jenkins

    # invoke :selenium
  end

  desc "app", "Installs app"
  def app
    invoke :postgres_create_user
    invoke :postgres_create_schemas

    invoke :mysql_create_user
    invoke :mysql_create_schemas

    invoke :project
  end

  desc "all", "Installs all required packages"
  def all
    invoke :general
    invoke :special
    invoke :app
  end

  desc "postgres_create_schemas", "Initializes postgres schemas"
  def postgres_create_schemas
    LinuxInstall.installer.postgres_create_schemas
  end

  desc "postgres_drop_schemas", "Drops postgres schemas"
  def postgres_drop_schemas
    LinuxInstall.installer.postgres_drop_schemas
  end

  desc "mysql_create_schemas", "Initializes mysql schemas"
  def mysql_create_schemas
    LinuxInstall.installer.mysql_create_schemas
  end

  desc "mysql_drop_schemas", "Drops mysql schemas"
  def mysql_drop_schemas
    LinuxInstall.installer.mysql_drop_schemas
  end

  desc "service", "Executes command for service"
  def service service, command
    LinuxInstall.installer.service service, command
  end

  desc "ssh", "ssh"
  def ssh
    #system "thor ssh:cp_key vagrant 22.22.22.22"
    system "ssh vagrant@22.22.22.22"
  end
end
