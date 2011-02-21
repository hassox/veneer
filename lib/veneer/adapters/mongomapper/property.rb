module MongoMapper
  module Document
    module VeneerInterface
      class Property < Veneer::Base::Property
        include Types
      end
    end
  end
end
