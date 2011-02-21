module ActiveRecord
  class Base
    module VeneerInterface
      class Property < Veneer::Base::Property
        include Types
      end
    end
  end
end
