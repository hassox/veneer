module ActiveRecord
  class Base
    module VeneerInterface
      class InstanceWrapper < Veneer::Base::InstanceWrapper
        def update(attributes = {})
          instance.update_attributes(attributes)
        end

        def save!
          if instance.save
            true
          else
            raise ::Veneer::Errors::NotSaved
          end
        end
      end # InstanceWrapper
    end # VeneerInterface
  end # Base
end # ActiveRecord
