module DataMapper
  module Resource
    module VeneerInterface
      class InstanceWrapper < ::Veneer::Base::InstanceWrapper

        def save!
          r = instance.save
          raise ::Veneer::Errors::NotSaved unless r
          r
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
