cookbook_file '/home/vagrant/.ssh/vagrant_id_rsa.pub' do
    source 'vagrant_id_rsa.pub'
end

execute 'copy pub key to auth_keys' do
    command 'cat /home/vagrant/.ssh/vagrant_id_rsa.pub >> /home/vagrant/.ssh/authorized_keys'
    not_if 'grep -w "vagrant insecure" /home/vagrant/.ssh/authorized_keys'
end
