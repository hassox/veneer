module MongoMapper
  module Document
    module VeneerInterface
      class ClassWrapper < Veneer::Base::ClassWrapper
        class Types
          def self.normalize(type)
            case type
              when ::MongoMapper::Extensions::ObjectId then String
              else type
            end
          end
        end
      end
    end
  end
end