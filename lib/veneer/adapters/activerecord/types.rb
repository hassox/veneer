module ActiveRecord
  class Base
    module VeneerInterface
      class ClassWrapper < Veneer::Base::ClassWrapper
        class Types
          def self.normalize(type)
            case type
            when :serial, :integer
              Integer
            else
              type
            end
          end
        end
      end
    end
  end
end