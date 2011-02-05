module MongoMapper
  module Document
    module VeneerInterface
      class ClassWrapper < Veneer::Base::ClassWrapper
        class Types
          def self.normalize(type)
            case type
              when MongoMapper::Extensions::ObjectId then String
              when MongoMapper::Extensions::Boolean then TrueClass
              when MongoMapper::Extensions::Binary then StringIO
              else type
            end
          end
        end
      end
    end
  end
end