$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'script_executor/executable'

class Showoff < Thor
  include Executable

  desc "all", "Runs showoff"
  def all
    execute <<-CODE
       cd presentation/virtualization
       showoff serve
    CODE
  end
end
