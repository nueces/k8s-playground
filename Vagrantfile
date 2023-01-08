# -*- mode: ruby -*-

# Specify minimum Vagrant version and Vagrant API version
Vagrant.require_version ">= 2.2"
VAGRANTFILE_API_VERSION = "2"

# Require YAML module
require 'yaml'

# Read ansible inventory
inventory = YAML.load_file('inventory.yml')

# Read defaults
defaults = inventory["all"]["vars"]
public_key = IO.read(defaults["ansible_ssh_public_key_file"]).strip()

# Create boxes
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Add ansible ssh public key to authorized_hosts
  config.vm.provision :shell, :inline => <<-EOF
    set -euo pipefail
    HOME_DIR=$(getent passwd "$SUDO_USER" | cut -d: -f6)
    AUTH_KEY_FILE=$HOME_DIR/.ssh/authorized_keys
    KEY_INSTALLED=$(grep -q '#{public_key}' $AUTH_KEY_FILE; echo $?)
    if [ $KEY_INSTALLED -ne 0 ]; then
        echo '#{public_key}' >> $AUTH_KEY_FILE
    fi
  EOF

  # Iterate through the "all" group. This simplify the implementation.
  inventory["all"]["hosts"].each do |name, values|
    config.vm.define name do |server|
      server.vm.box = defaults["vagrant_box"]
      server.vm.network "private_network", ip: values["ansible_host"]
      server.vm.provider :virtualbox do |vbox|
        vbox.name   = name
        vbox.cpus   = defaults["vagrant_cpus"]
        vbox.memory = defaults["vagrant_memory"]
      end
    end
  end
end
