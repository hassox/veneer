  module DataMapper
    module Resource
      module VeneerInterface
        class InstanceWrapper < ::Veneer::Base::InstanceWrapper

          def save
            result = false
            instance.class.transaction do
              result = instance.save
            end
            result
          rescue ::Veneer::Errors::BeforeSaveError => e
            handle_before_save_error(e)
          end

          def save!
            result = false
            instance.class.transaction do
              result = instance.save
              raise ::Veneer::Errors::NotSaved unless result
              result
            end
            result
          rescue ::Veneer::Errors::BeforeSaveError => e
            raise ::Veneer::Errors::NotSaved, e.message
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
