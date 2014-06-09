require File.expand_path('spec_helper', File.dirname(__FILE__))

require 'thor'
load 'thor/linux_install.thor'

# rdebug-ide --port 1234 --dispatcher-port 26162 -- ~/.rvm/gems/ruby-1.9.3-p545@linux_ruby_dev_install/bin/rdebug-ide  ~/.rvm/gems/ruby-1.9.3-p545@linux_ruby_dev_install/bin/thor linux_install:test

describe LinuxInstall do

  describe "#test" do
    it "calls test method" do
      subject.test
    end
  end
end