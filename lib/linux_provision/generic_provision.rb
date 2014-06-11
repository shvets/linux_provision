require 'json'
require "highline"

require 'text_interpolator'
require 'script_executor/executable'
require 'script_executor/script_locator'

class GenericProvision
  include Executable, ScriptLocator

  attr_reader :interpolator, :env, :script_list, :server_info

  def initialize config_file_name, scripts_file_names
    @interpolator = TextInterpolator.new

    @env = read_config(config_file_name)

    @script_list = {}

    scripts_file_names.each do |name|
      @script_list.merge!(scripts(name))
    end

    create_script_methods

    @server_info = env[:node] ? env[:node] : {}
  end


  def create_script_methods
    script_list.keys.each do |name|
      singleton_class.send(:define_method, name.to_sym) do
        self.send :run, server_info, name.to_s, env
      end
    end
  end

  protected

  def read_config config_file_name
    hash = JSON.parse(File.read(config_file_name), :symbolize_names => true)

    interpolator.interpolate hash
  end

  def terminal
    @terminal ||= HighLine.new
  end

  def ask_password message
    terminal.ask(message) { |q| q.echo = "*" }
  end

  def run server_info, script_name, params
    execute(server_info) { evaluate_script_body(script_list[script_name], params, :string) }
  end

  def run_command server_info, command
    execute(server_info.merge({script: command}))
  end

end
