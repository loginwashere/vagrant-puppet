# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.provision :shell do |shell|
    shell.inline = '
      apt-get update

      /bin/bash /vagrant/puppet/files/install.sh /vagrant/puppet/modules

      mkdir -pv /etc/puppet/hieradata/dev

      cp -v /vagrant/puppet/dev.yaml /etc/puppet/hieradata/dev.yaml
    '
  end

  config.vm.synced_folder "./www/site/", "/var/www/dev.192.168.33.10.xip.io/", id: "dev.192.168.33.10.xip.io", type: nil,
      group: 'vagrant', owner: 'vagrant', mount_options: ["dmode=775", "fmode=764"]

  config.vm.provision :puppet do |puppet|
    puppet.module_path  = "puppet/modules"
    puppet.manifest_file = "default.pp"
    puppet.manifests_path = "puppet/manifests"
    # pass the environment variable to puppet facter
    puppet.facter = {
      "environment" => ENV['APP_ENV'] ? ENV['APP_ENV'] : 'dev'
    }

#    puppet.hiera_config_path  = "puppet/hiera.yaml"
    puppet.options = "--verbose --debug"
  end
end
