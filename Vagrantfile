# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "centos/7"
  
  config.vm.network "forwarded_port", guest: 8080, host: 8082
  config.vm.network "private_network", ip: "192.168.66.10"

  config.vm.provision "chef_solo" do |chef|
    chef.add_recipe "jenkins::install_server"
    chef.add_recipe "jenkins::install_plugins"
    chef.add_recipe "jenkins::create_job"
  end



  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"
  
end
