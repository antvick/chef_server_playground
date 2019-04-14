# # encoding: utf-8

# Inspec test for recipe chef-server::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/


describe package('chef-server-core') do
    it { should be_installed }
    its('version') { should eq '12.19.31-1' }
end

describe command('chef-server-ctl user-list | grep -w administrator') do
    its('stdout') { should include "administrator" }
end

describe command('chef-server-ctl user-list | grep -w vagrant') do
    its('stdout') { should include "vagrant" }
end

describe command('chef-server-ctl org-list | grep -w test_organisation') do
    its('stdout') { should include "test_organisation" }
end

