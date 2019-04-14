# -*- mode: ruby -*-
# vi: set ft=ruby :

host_user = (ENV['USER'] || ENV['USERNAME']).downcase
this_dir = File.dirname(__FILE__)
chef_server = "192.168.200.5"
chef_workstation = "192.168.200.6"
chef_node = "192.168.200.7"
chef_version = '13.3.42'
chef_roles = "#{this_dir}/roles"
chef_envs = "#{this_dir}/environments"
chef_databags = "#{this_dir}/databags"
vm_image = "generic/debian9"

Vagrant.configure("2") do |config|
    config.berkshelf.enabled = false
    config.vm.box_check_update = true

    config.vm.define "chef-server" do |server|
        server.vm.provider "virtualbox" do |vb|
            vb.gui          = false
            vb.memory       = 4096
            vb.cpus         = 4
            vb.customize ["modifyvm", :id, "--cpuexecutioncap", "100"]
            vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
        end
        server.vm.hostname         = "chef-server"
        server.vm.box              = vm_image
        server.vm.network "private_network", ip: chef_server
        config.vm.provision 'chef_solo' do |chef|
            chef.version = chef_version
            chef.roles_path = chef_roles
            chef.environments_path = chef_envs
            chef.data_bags_path = chef_databags
            chef.add_role("chef-server")
            chef.environment = "dev"
        end
    end

    config.vm.define "chef-node" do |node|
        node.vm.provider "virtualbox" do |vb|
            vb.gui          = false
            vb.memory       = 2048
            vb.cpus         = 4
            vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
        end
        node.vm.hostname         = "chef-node"
        node.vm.box              = vm_image
        node.vm.network "private_network", ip: chef_node
        node.vm.provision 'shell', path: "./node-provision.sh"
    end

    config.vm.define "chef-workstation" do |workstation|
        workstation.vm.provider "virtualbox" do |vb|
            vb.gui          = false
            vb.memory       = 2048
            vb.cpus         = 4
            vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
        end
        workstation.vm.hostname         = "chef-workstation"
        workstation.vm.box              = vm_image
        workstation.vm.network "private_network",  ip: chef_workstation
        workstation.vm.synced_folder "./", "/vagrant"
        workstation.vm.provision "shell",
            inline: "wget https://packages.chef.io/files/stable/chefdk/3.8.14/ubuntu/16.04/chefdk_3.8.14-1_amd64.deb && sudo dpkg -i chefdk_3.8.14-1_amd64.deb"
        workstation.vm.provision 'chef_solo' do |chef|
            chef.version = chef_version
            chef.roles_path = chef_roles
            chef.environments_path = chef_envs
            chef.data_bags_path = chef_databags
            chef.add_role("chef-workstation")
            chef.environment = "dev"
        end


    end
end
