$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'linux_provision/linux_provision'

class LinuxInstall < Thor
  @installer = LinuxProvision.new self, ".linux_provision.json", [File.expand_path("demo_scripts.sh", File.dirname(__FILE__))]

  class << self
    attr_reader :installer
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

    # invoke :mysql_create_user
    # invoke :mysql_create_schemas

    # invoke :selenium

    # invoke :project
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
end
