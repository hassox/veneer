require 'hashie'
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
  autoload :Lint,         'veneer/lint'


  module Base
    autoload :ClassWrapper,     'veneer/base/class_wrapper'
    autoload :InstanceWrapper,  'veneer/base/instance_wrapper'
    autoload :Property,         'veneer/base/property'
  end

  def self.model_classes
    Base::ClassWrapper.subclasses.map{|adapter| adapter.model_classes }.flatten.compact
  end
end

