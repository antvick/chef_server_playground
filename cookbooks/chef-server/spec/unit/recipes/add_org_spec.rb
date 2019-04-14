#
# Cookbook:: chef-server
# Spec:: server_install
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'chef-server::add_org' do
    let(:chef_run) do
        ChefSpec::SoloRunner.new(DEBIAN_OPTS) do |node|
            env = Chef::Environment.new
            env.name 'dev'
            allow(node).to receive(:chef_environment).and_return(env.name)
            allow(Chef::Environment).to receive(:load).and_return(env)
        end.converge 'chef-server::add_org'
    end

    context 'Anywhere' do
        context 'Not Production' do
            let(:environment) { 'dev' }
            before do
                stub_command("chef-server-ctl org-list | grep -w test_organisation").and_return(false)
                stub_command("chef-server-ctl user-show vagrant -l | grep -w organizations | grep -w test_organisation").and_return(false)
                stub_data_bag('chef-server').and_return(['users'])
                stub_data_bag_item('chef-server', 'users').and_return({
                  "id"=>"users",
                  "dev" => {
                    "admin"=> {
                      "email"=>"test",
                      "password"=>"test"
                    },
                    "users"=> {
                      "vagrant"=> {
                        "description"=>"test",
                        "first_name"=>"test",
                        "last_name"=>"test",
                        "email"=>"test",
                        "password"=>"test"
                      }
                    }
                  }
                })
            end

            it 'converges successfully' do
                expect { chef_run }.to_not raise_error
            end

            it 'adds organisation to chef-server' do
                expect(chef_run).to run_execute('add chef-server organisation').with(
                    command: 'chef-server-ctl org-create test_organisation "Test Organisation Ltd." --association_user administrator -f /etc/chef/test_organisation-validator.pem'
                )
            end

            it 'adds vagrant user to test org on chef-server' do
                expect(chef_run).to run_execute('add vagrant to test org').with(
                    command: 'chef-server-ctl org-user-add test_organisation vagrant --admin'
                )
            end
        end
    end
end
