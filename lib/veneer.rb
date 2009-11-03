require 'active_support/core_ext/hash'
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), "lib"))

require 'veneer/core_ext/kernel'

unless defined?(BasicObject)
  begin
    require 'blankslate'
    ::BasicObject = BlankSlate
    class BasicObject
      def ==(other)
        object_id == other.object_id
      end

      def equal?(other)
        object_id == other.object_id
      end
    end
  rescue => e
    puts "Please install builder: gem install builder"
    raise e.class, e.message, e.backtrace
  end
end

module Veneer
  autoload :Errors,       'veneer/errors'
  autoload :Proxy,        'veneer/proxy'
  autoload :Conditional,  'veneer/base/conditional'

  module Base
    autoload :ClassWrapper,     'veneer/base/class_wrapper'
    autoload :InstanceWrapper,  'veneer/base/instance_wrapper'
  end
end

