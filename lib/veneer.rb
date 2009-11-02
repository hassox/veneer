require 'active_support/core_ext/hash'
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "lib"))

require 'veneer/core_ext/kernel'
module Veneer
  autoload :Errors,       'veneer/errors'
  autoload :Proxy,        'veneer/proxy'
  autoload :Conditional,  'veneer/base/conditional'

  module Base
    autoload :ClassWrapper,     'veneer/base/class_wrapper'
    autoload :InstanceWrapper,  'veneer/base/instance_wrapper'
  end
end

