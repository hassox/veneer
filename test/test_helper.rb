require 'rubygems'
require 'test/unit'
require 'shoulda'

Dir[File.join(File.dirname(__FILE__), "support", "**/*.rb")].each{|f| require f}
Dir[File.join(File.dirname(__FILE__), "macros", "**/*.rb")].each{|f| require f}

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'veneer'

class Test::Unit::TestCase
  include Veneer::Test::Helpers
end


