module MongoMapper
  module Document
    module VeneerInterface
      class ClassWrapper < Veneer::Base::ClassWrapper
        class Types
          def self.normalize(type)
            case type
              # when ::MongoMapper::Extensions::Array then :serialized
              # when ::MongoMapper::Extensions::Binary then :binary
              # when ::MongoMapper::Extensions::Boolean then :boolean
              # when ::MongoMapper::Extensions::Date then :date
              # when ::MongoMapper::Extensions::Float then :float
              # when ::MongoMapper::Extensions::Hash then :serialized
              # when ::MongoMapper::Extensions::Integer then :integer
              # when ::MongoMapper::Extensions::NilClass then :serialized
              # when ::MongoMapper::Extensions::Object then :serialized
              when ::MongoMapper::Extensions::ObjectId then String
              # when ::MongoMapper::Extensions::Set then :serialized
              # when ::MongoMapper::Extensions::String then :string
              # when ::MongoMapper::Extensions::Time then :time
              else type
            end
          end
        end
      end
    end
  end
end