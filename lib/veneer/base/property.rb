module Veneer
  module Base
    class Property < Hashie::Dash
      attr_reader :parent

      property :constraints
      property :name
      property :type
      property :primary
      
      alias :primary? :primary

      def initialize(parent, properties)
        @parent = parent
        super properties.merge(:type => normalize(properties[:type]))
      end

      def normalize(properties)
        ::Kernel.raise ::Veneer::Errors::NotImplemented
      end

      def validators
        parent.validators_on(name)
      end
    end
  end
end
