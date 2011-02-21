module DataMapper
  module Resource
    module VeneerInterface
      class Property < Veneer::Base::Property
        include Types
      end
    end
  end
end
