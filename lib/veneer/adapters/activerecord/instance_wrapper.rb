module ActiveRecord
  class Base
    module VeneerInterface
      class InstanceWrapper < Veneer::Base::InstanceWrapper
        def update(attributes = {})
          instance.update_attributes(attributes)
        end

        def save!
          instance.save!
        rescue ActiveRecord::RecordInvalid => e
          raise ::Veneer::Errors::NotSaved
        end

        def save
          instance.save
        end
      end # InstanceWrapper
    end # VeneerInterface
  end # Base
end # ActiveRecord
