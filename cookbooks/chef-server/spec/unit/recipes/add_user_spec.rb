#
# Cookbook:: chef-server
# Spec:: server_install
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'chef-server::add_user' do
    let(:chef_run) do
        ChefSpec::SoloRunner.new(DEBIAN_OPTS) do |node|
            env = Chef::Environment.new
            env.name 'dev'
            allow(node).to receive(:chef_environment).and_return(env.name)
            allow(Chef::Environment).to receive(:load).and_return(env)
        end.converge 'chef-server::add_user'
    end

    context 'Anywhere' do
        context 'Not Production' do
            let(:environment) { 'dev' }

            before do
                stub_command("chef-server-ctl user-list | grep -w administrator").and_return(false)
                stub_command("chef-server-ctl user-list | grep -w vagrant").and_return(false)
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

            it 'creates keys directory' do
              expect(chef_run).to create_directory('/home/vagrant/chef-keys')
            end

            it 'adds chef-server admin user' do
              expect(chef_run).to run_execute('add chef-server admin user').with(
                command: "chef-server-ctl user-create administrator administrator administrator test test -f /etc/chef/administrator.pem"
              )
            end

            it 'adds chef-server vagrant user' do
              expect(chef_run).to run_execute('add chef-server vagrant user').with(
                command: "chef-server-ctl user-create vagrant test test test test -f /home/vagrant/chef-keys/vagrant.pem"
              )
            end

            # test environment specific stuff
            it 'converges successfully' do
                expect { chef_run }.to_not raise_error
            end
        end
    end
end
