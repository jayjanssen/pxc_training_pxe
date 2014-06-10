# -*- mode: ruby -*-
# vi: set ft=ruby :

require File.dirname(__FILE__) + '/lib/vagrant-common.rb'

name = 'pxc-training-pxe'

Vagrant.configure("2") do |config|
	# Every Vagrant virtual environment requires a box to build off of.
	config.vm.hostname = name
	config.vm.box = "perconajayj/centos-x86_64"
	config.ssh.username = "root"
	config.vm.network :private_network, ip: '10.10.10.5'
  
  # Provisioners
  provision_puppet( config, "base.pp" )
  
  # Custom provisioning for PXE / DHCP / TFTP / HTTPD
  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = ["vm", "/vagrant/custom_manifests"]
    puppet.options = "--verbose --modulepath /vagrant/custom_modules"
    puppet.manifest_file = "pxe.pp"
  end
  
  # Providers
  provider_virtualbox( name, config, 256 )
  

  
end
