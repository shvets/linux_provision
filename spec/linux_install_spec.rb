require File.expand_path('spec_helper', File.dirname(__FILE__))

require 'thor'
load 'thor/linux_install.thor'

require "thor/runner"
# $thor_runner = true

# rdebug-ide --port 1234 --dispatcher-port 26162 -- /Users/ashvets/.rvm/gems/ruby-1.9.3-p545@linux_provision/bin/rdebug-ide /Users/ashvets/Dropbox/alex/work/projects/linux_provision/Thorfile linux_install:test

describe LinuxInstall do

  describe "#test" do
    it "calls test method" do
      #subject.test
      args = ARGV
      args = ['linux_install:test']

      Thor::Runner.start(args)
    end
  end
end