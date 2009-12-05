module MongoMapper
  module Document
    module VeneerInterface
      class InstanceWrapper < ::Veneer::Base::InstanceWrapper
        def save!
          instance.save!
        rescue
          raise ::Veneer::Errors::NotSaved
        end
      end
    end
  end
end
