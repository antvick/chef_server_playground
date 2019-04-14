remote_file '/tmp/chef-server.deb' do
    source node['chef_server']['dpkg']['deb_source']
end

dpkg_package '/tmp/chef-server.deb'

execute 'configure chef-server' do
    command 'chef-server-ctl reconfigure'
end
