# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  #
  # jenkins
  #
  config.vm.define "jenkins", :primary => true do |jenkins|
    jenkins.vm.box = "boxcutter/centos71"
    
    jenkins.vm.provision "chef_solo" do |chef|
      chef.add_recipe "jenkins::install_server"
      chef.add_recipe "jenkins::install_plugins"
      chef.add_recipe "jenkins::create_job"
    end
    
    jenkins.vm.network "private_network", :ip => "192.168.66.10"
    jenkins.vm.network "forwarded_port", guest: 8080, host: 8082
  end
  
  #
  # nexus
  #
  config.vm.define "nexus" do |nexus|
    nexus.vm.box = "centos/7"
    
    nexus.vm.provision "chef_solo" do |chef|
      chef.add_recipe "liatrio::home"
      chef.add_recipe "nexus::install"
    end
    
    nexus.vm.network "private_network", :ip => "192.168.56.20"
    nexus.vm.network "forwarded_port", guest: 8081, host: 8085
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
