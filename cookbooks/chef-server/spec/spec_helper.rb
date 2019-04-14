require 'chefspec'
require 'chefspec/berkshelf'

DEBIAN_OPTS = {
  platform: 'debian',
  version: '9.4',
}.freeze

at_exit { ChefSpec::Coverage.report! }
