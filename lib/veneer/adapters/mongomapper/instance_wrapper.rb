module MongoMapper
  module Document
    module VeneerInterface
      class InstanceWrapper < ::Veneer::Base::InstanceWrapper
        def save!
          instance.save!
        rescue ::Veneer::Errors::BeforeSaveError => e
          raise ::Veneer::Errors::NotSaved, e.message
        rescue => e
          raise ::Veneer::Errors::NotSaved, e.message
        end

        def save
          instance.save
        rescue ::Veneer::Errors::BeforeSaveError => e
          handle_before_save_error(e)
        end

        def update(*args)
          instance.update(*args)
        rescue ::Veneer::Errors::BeforeSaveError => e
          handle_before_save_error(e)
        end
      end
    end
  end
end
