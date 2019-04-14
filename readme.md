# Chef Playground

## For testing knife administration and configuration options

Provides a vagrant environment which includes:

* a chef-server
* a chef-node
* a chef-workstation with ChefDK

### Dependencies

* `./run setup`

### Usage

* to build the dev environment: `./run dev`
* `vagrant ssh chef-workstation` and `knife` away with a server and node to play with...
