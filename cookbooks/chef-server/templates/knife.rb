current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "administrator"
client_key               "/home/vagrant/chef/.chef/administrator.pem"
chef_server_url          "https://chef-server/organizations/test_organisation"
syntax_check_cache_path  "/home/vagrant/chef/.chef/syntaxcache"
cookbook_path            ["/vagrant/cookbooks"]
