module Veneer
  module Base
    class Property < Hashie::Dash
      property :name
      property :type
      property :length
      property :primary
      
      alias :primary? :primary
    end
  end
end