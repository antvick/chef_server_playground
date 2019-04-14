execute 'add chef-server organisation' do
    command 'chef-server-ctl org-create test_organisation "Test Organisation Ltd." --association_user administrator -f /etc/chef/test_organisation-validator.pem'
    not_if 'chef-server-ctl org-list | grep -w test_organisation'
end

users_data = data_bag_item('chef-server', 'users')[node.chef_environment]

users_data['users'].each do |user, _user_info|
    execute "add #{user} to test org" do
        command "chef-server-ctl org-user-add test_organisation #{user} --admin"
        not_if "chef-server-ctl user-show #{user} -l | grep -w organizations | grep -w test_organisation"
    end
end
