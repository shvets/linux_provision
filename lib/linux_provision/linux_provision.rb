require 'linux_provision/generic_provision'

class LinuxProvision < GenericProvision

  USER_LOCAL_BIN = "/usr/local/bin"

  def initialize config_file_name=".linux_provision.json", scripts_file_names=[]
    scripts_file_names.unshift(File.expand_path("linux_provision_scripts.sh", File.dirname(__FILE__))) # make it first

    super
  end

  def postgres_create_schemas
    env[:postgres][:app_schemas].each do |schema|
      run(server_info, "postgres_create_schema", env.merge(schema: schema))
    end
  end

  def mysql_create_schemas
    env[:mysql][:app_schemas].each do |schema|
      run(server_info, "mysql_create_schema", env.merge(schema: schema))
    end
  end

  def create_postgres_user app_user, schema
    run("create_postgres_user", binding)
  end

    # execute(server_info) { "/usr/local/bin/dropuser #{app_user}" }
    # execute(server_info) { "/usr/local/bin/dropdb #{schema}" }

  # def prepare
  #   env['password'] = ask_password("Enter password for #{env[:node][:user]}: ")
  #
  #   run(server_info.merge(capture_output: false), "prepare", env)
  # end
  #
  # def rvm_install
  #   installed = package_installed '#{ENV[\'HOME\']}/.rvm/bin/rvm'
  #
  #   if installed
  #     puts "rvm already installed."
  #   else
  #     run(server_info, "rvm", env)
  #   end
  # end
  #
  # def npm_install
  #   installed = package_installed "#{USER_LOCAL_BIN}/npm"
  #
  #   if installed
  #     puts "npm already installed."
  #   else
  #     run(server_info, "npm", env)
  #   end
  # end

  # def qt_install
  #   installed = package_installed "#{USER_LOCAL_BIN}/qmake"
  #
  #   if installed
  #     puts "qt already installed."
  #   else
  #     run(server_info, "qt", env)
  #   end
  # end
  #
  # def mysql_install
  #   installed = package_installed "#{USER_LOCAL_BIN}/mysql"
  #
  #   if installed
  #     puts "mysql already installed."
  #   else
  #     run(server_info, "mysql", env)
  #   end
  # end
  #
  # def mysql_restart
  #   started = service_started("homebrew.mxcl.mysql")
  #
  #   run(server_info, "mysql_restart", env.merge({started: started}))
  # end
  #
  # def postgres_install
  #   installed = package_installed "#{USER_LOCAL_BIN}/postgres"
  #
  #   if installed
  #     puts "postgres already installed."
  #   else
  #     run(server_info, "postgres", env)
  #   end
  # end
  #
  # def postgres_restart
  #   started = service_started("homebrew.mxcl.postgres")
  #
  #   run(server_info, "postgres_restart", env.merge({started: started}))
  # end
  #
  # def postgres_stop
  #   run server_info, "postgres_stop", env
  # end
  #
  # def postgres_start
  #   run server_info, "postgres_start", env
  # end
  #
  # def ruby_install
  #   installed = package_installed "#{ENV['HOME']}/.rvm/rubies/ruby-1.9.3-p429/bin/ruby"
  #
  #   if installed
  #     puts "ruby already installed."
  #   else
  #     run(server_info, "ruby", env)
  #   end
  # end
  #
  # def jenkins_install
  #   installed = package_installed "/usr/local/opt/jenkins/libexec/jenkins.war"
  #
  #   if installed
  #     puts "jenkins already installed."
  #   else
  #     run(server_info, "jenkins", env)
  #   end
  # end
  #
  # def jenkins_restart
  #   started = service_started("homebrew.mxcl.jenkins")
  #
  #   run(server_info, "jenkins_restart", env.merge({started: started}))
  # end
  #
  # def selenium_install
  #   installed = package_installed "/usr/local/opt/selenium-server-standalone/selenium-server-standalone*.jar"
  #
  #   if installed
  #     puts "selenium already installed."
  #   else
  #     run(server_info, "selenium", env)
  #   end
  # end
  #
  # def selenium_restart
  #   started = service_started("homebrew.mxcl.selenium-server-standalone")
  #
  #   run(server_info, "selenium_restart", env.merge({started: started}))
  # end
  #
  # def postgres_create user, schemas
  #   create_postgres_user user, schemas.first
  #
  #   schemas.each do |schema|
  #     create_postgres_schema user, schema
  #   end
  # end
  #
  # def postgres_drop user, schemas
  #   schemas.each do |schema|
  #     drop_postgres_schema schema
  #   end
  #
  #   drop_postgres_user user, schemas.first
  # end
  #
  # def postgres_test schema
  #   result = get_postgres_schemas schema
  #
  #   puts result
  # end
  #
  # def package_installed package_path
  #   result = run server_info.merge(:suppress_output => true, :capture_output => true),
  #                "package_installed", env.merge({package_path: package_path})
  #
  #   result.chomp == package_path
  # end

end
