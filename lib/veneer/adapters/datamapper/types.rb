module DataMapper
  module Resource
    module VeneerInterface
      class ClassWrapper < ::Veneer::Base::ClassWrapper
        class Types
          def self.normalize(type)
            case type
            when ::DataMapper::Property::Integer then ::Integer
            else type
            end
          end
        end
      end
    end
  end
end