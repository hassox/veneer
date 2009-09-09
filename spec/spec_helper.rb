require 'rubygems'
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'veneer'
require 'spec'
require 'spec/autorun'

require 'support/helpers'
require 'shared/veneer_constants_interface_spec'
require 'shared/class_wrapper/create_spec'

Spec::Runner.configure do |config|
  config.include(Veneer::Spec::Helpers)
end
