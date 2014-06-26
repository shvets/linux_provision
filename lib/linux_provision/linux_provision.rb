require 'script_executor/base_provision'

class LinuxProvision < BaseProvision

  USER_LOCAL_BIN = "/usr/local/bin"

  def initialize parent_class, config_file_name=".linux_provision.json", scripts_file_names=[]
    scripts_file_names.unshift(File.expand_path("linux_provision_scripts.sh", File.dirname(__FILE__))) # make it first

    super
  end

  def postgres_create_schemas
    env[:postgres][:app_schemas].each do |schema|
      run(server_info, "postgres_create_schema", env.merge(schema: schema))
    end
  end

  def postgres_drop_schemas
    env[:postgres][:app_schemas].each do |schema|
      run(server_info, "postgres_drop_schema", env.merge(schema: schema))
    end
  end

  def mysql_create_schemas
    env[:mysql][:app_schemas].each do |schema|
      run(server_info, "mysql_create_schema", env.merge(schema: schema))
    end
  end

  def mysql_drop_schemas
    env[:mysql][:app_schemas].each do |schema|
      run(server_info, "mysql_drop_schema", env.merge(schema: schema))
    end
  end
end
