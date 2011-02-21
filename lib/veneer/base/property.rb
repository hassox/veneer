module Veneer
  module Base
    class Property < Hashie::Dash
      property :name
      property :type
      property :length
      property :primary
      
      alias :primary? :primary

      def initialize(properties)
        super properties.merge(:type => normalize(properties[:type]))
      end
    end
  end
end
