module Veneer
  module Base
    class Property < Hashie::Dash
      property :type
      property :name
      property :length
      property :nullable
    end
  end
end