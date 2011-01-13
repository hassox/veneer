require 'rubygems'
require 'test/unit'
require 'shoulda'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(Dir.pwd)

require 'veneer'
require 'veneer/lint'

Dir[File.join(File.dirname(__FILE__),"support", "**/*.rb")].each{|f| require f}

$validations = []

class Test::Unit::TestCase
  include Veneer::Test::Helpers
end


