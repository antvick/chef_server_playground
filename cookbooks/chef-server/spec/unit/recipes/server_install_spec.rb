#
# Cookbook:: chef-server
# Spec:: server_install
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'chef-server::server_install' do
    context 'When all attributes are default, on debian 9.3' do
        let(:chef_run) { ChefSpec::SoloRunner.new(DEBIAN_OPTS).converge(described_recipe) }

        it 'converges successfully' do
            expect { chef_run }.to_not raise_error
        end

        it 'downloads chef-server deb file' do
            expect(chef_run).to create_remote_file('/tmp/chef-server.deb').with(
                source: 'https://packages.chef.io/files/stable/chef-server/12.19.31/ubuntu/16.04/chef-server-core_12.19.31-1_amd64.deb'
            )
        end

        it 'installs chef-server dpkg package' do
            expect(chef_run).to install_dpkg_package('/tmp/chef-server.deb')
        end

        it 'executes reconfigure command for chef-server' do
            expect(chef_run).to run_execute('chef-server-ctl reconfigure')
        end
    end
end
