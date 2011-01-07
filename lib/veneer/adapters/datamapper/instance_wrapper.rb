  module DataMapper
    module Resource
      module VeneerInterface
        class InstanceWrapper < ::Veneer::Base::InstanceWrapper

          def save
            instance.save
          end

          def save!
            result = false
            result = instance.save
            raise ::Veneer::Errors::NotSaved unless result
            result
          end

          def new_record?
            instance.respond_to?(:new?) ? instance.new? : instance.new_record?
          end

          def destroy
            instance.destroy
            self
          end
        end
      end
    end
  end
