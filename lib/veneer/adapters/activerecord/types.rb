module ActiveRecord
  class Base
    module VeneerInterface
      class ClassWrapper < Veneer::Base::ClassWrapper
        class Types
          def self.normalize(type_name)
            case type_name
            when :serial, :integer
              Integer
            else
              type_name
            end
          end
        end
      end
    end
  end
end