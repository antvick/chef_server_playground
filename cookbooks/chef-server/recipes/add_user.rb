users_data = data_bag_item('chef-server', 'users')

admin = users_data[node.chef_environment]['admin']
execute "add chef-server admin user" do
    command "chef-server-ctl user-create administrator administrator administrator #{admin['email']} #{admin['password']} -f /etc/chef/administrator.pem"
    not_if "chef-server-ctl user-list | grep -w administrator"
end

users_data[node.chef_environment]['users'].each do |user, user_info|
    directory "/home/#{user}/chef-keys" do
        recursive true
    end
    execute "add chef-server #{user} user" do
        command "chef-server-ctl user-create #{user} #{user_info['first_name']} #{user_info['last_name']} #{user_info['email']} #{user_info['password']} -f /home/#{user}/chef-keys/#{user}.pem"
        not_if "chef-server-ctl user-list | grep -w #{user}"
    end
end
