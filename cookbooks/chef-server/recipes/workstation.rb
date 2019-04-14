chef_repo = '/home/vagrant/chef'
node_hostname = 'chef-node'
server_hostname = 'chef-server'

directory "#{chef_repo}/.chef" do
  recursive true
  user 'vagrant'
  group 'vagrant'
end

execute 'copy cookbooks to chef-workstation' do
  command "cp -r /vagrant/cookbooks #{chef_repo}/cookbooks"
  cwd chef_repo
end

execute 'add chef-server hostname' do
    command "echo \"192.168.200.5 #{server_hostname} chef\" >> /etc/hosts"
    not_if "grep -w \"192.168.200.5 #{server_hostname} chef\" /etc/hosts"
end

execute 'add chef-node hostname' do
    command "echo \"192.168.200.7 #{node_hostname} node\" >> /etc/hosts"
    not_if "grep -w \"192.168.200.7 #{node_hostname} node\" /etc/hosts"
end

cookbook_file '/home/vagrant/.ssh/id_rsa' do
    source 'vagrant_id_rsa'
    mode '0600'
    owner 'vagrant'
    group 'vagrant'
end

execute 'add chef-server host-key' do
    command "ssh-keyscan #{node['chef-server']['ip']} >> /home/vagrant/.ssh/known_hosts"
    not_if "grep -w #{node['chef-server']['ip']} /home/vagrant/.ssh/known_hosts"
    user 'vagrant'
    group 'vagrant'
end

execute 'fetch administrator key from chef-server' do
    command "scp vagrant@#{node['chef-server']['ip']}:/etc/chef/administrator.pem #{chef_repo}/.chef/administrator.pem"
    creates "#{chef_repo}/.chef/admin.pem"
    user 'vagrant'
end

# execute 'fetch test organisation key from chef-server' do
#     command "scp vagrant@#{node['chef-server']['ip']}:/etc/chef/test_organisation-validator.pem #{chef_repo}/.chef/test_organisation-validator.pem"
#     creates "#{chef_repo}/.chef/test_organisation-validator.pem"
#     user 'vagrant'
# end

template "#{chef_repo}/.chef/knife.rb" do
    source 'knife.rb'
end

execute 'cert config' do
    command 'su vagrant -c "knife ssl fetch"'
    creates "#{chef_repo}/.chef/trusted_certs/chef-server.crt"
    cwd chef_repo
end

execute 'upload cookbooks to chef-server' do
    command 'su vagrant -c "knife upload /"' # or specify a single cookbook
    cwd chef_repo
end

execute "bootstrap the chef node" do
    command "su vagrant -c \"knife bootstrap 192.168.200.5 --sudo -N chef-node -x vagrant -P vagrant --use-sudo-password\""
    not_if "knife node list | grep chef-node"
    cwd chef_repo
end
