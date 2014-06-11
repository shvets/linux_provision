$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'linux_provision/linux_provision'

class LinuxInstall < Thor

  def self.installer
    @@installer ||= LinuxProvision.new ".linux_provision.json", ["thor/demo_scripts.sh"]
  end

  def self.create_thor_script_methods parent_class
    installer.script_list.each do |name, value|
      title = installer.script_title(value)

      title = title.nil? ? name : title

      parent_class.send :desc, name, title
      parent_class.send(:define_method, name.to_sym) do
        self.class.installer.send name.to_sym
      end
    end

  end

  create_thor_script_methods self

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
    self.class.installer.postgres_create_schemas
  end

  desc "mysql_create_schemas", "Initializes mysql schemas"
  def mysql_create_schemas
    self.class.installer.mysql_create_schemas
  end
end
