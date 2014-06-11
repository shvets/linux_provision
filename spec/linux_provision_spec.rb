require File.expand_path('spec_helper', File.dirname(__FILE__))

require 'linux_provision/linux_provision'

describe LinuxProvision do
  subject { LinuxProvision.new ".linux_provision.json", ["thor/demo_scripts.sh"] }

  describe "#test" do
    it "calls test method" do
      subject.test
    end
  end
end
