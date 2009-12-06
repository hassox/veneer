module ActiveRecord
  class Base
    module VeneerInterface
      class InstanceWrapper < Veneer::Base::InstanceWrapper
        def update(attributes = {})
          instance.update_attributes(attributes)
        rescue Veneer::Errors::BeforeSaveError => e
          handle_before_save_error(e)
        end

        def save!
          instance.save!
        rescue ActiveRecord::RecordInvalid, Veneer::Errors::BeforeSaveError=> e
          raise ::Veneer::Errors::NotSaved, e.message
        end

        def save
          instance.save
        rescue Veneer::Errors::BeforeSaveError => e
          handle_before_save_error(e)
        end
      end # InstanceWrapper
    end # VeneerInterface
  end # Base
end # ActiveRecord
