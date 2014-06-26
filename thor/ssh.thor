require "highline/import"
require 'script_executor/executable'
require 'script_executor/script_locator'
require 'file_utils/file_utils'

class Ssh < Thor
  include Executable, ScriptLocator, FileUtils

  desc "gen_key", "Generates ssh key"
  def gen_key
    scripts = scripts(__FILE__)

    execute { evaluate_script_body(scripts['gen_key'], binding) }
  end

  desc "cp_key $host", "Copies public key to remote host"
  def cp_key(user, host)
    scripts = scripts(__FILE__)

    execute { evaluate_script_body(scripts['cp_key1'], binding) }

    execute(:remote => true, :domain => host, :user => user) do
      evaluate_script_body(scripts['cp_key2'], binding)
    end
  end
end

__END__

[gen_key]

echo "Generating ssh key..."

cd ~/.ssh
ssh-keygen

[cp_key1]

echo "Copying public key to remote server..."

echo <%= user %>
echo <%= host %>

scp ~/.ssh/id_rsa.pub <%= user %>@<%= host %>:~/pubkey.txt

[cp_key2]

mkdir -p ~/.ssh
chmod 700 .ssh
cat pubkey.txt >> ~/.ssh/authorized_keys
rm ~/pubkey.txt
chmod 600 ~/.ssh/*
