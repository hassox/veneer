module DataMapper
  module Resource
    module VeneerInterface
      class ClassWrapper < ::Veneer::Base::ClassWrapper
        class Types
          def self.normalize(type)
            case type
            # when ::DataMapper::Property::Binary then :binary
            # when ::DataMapper::Property::Boolean then :boolean
            # when ::DataMapper::Property::Class then :string
            # when ::DataMapper::Property::Date then :date
            # when ::DataMapper::Property::DateTime then :datetime
            # when ::DataMapper::Property::Decimal then :datetime
            # when ::DataMapper::Property::Discriminator then :string
            # when ::DataMapper::Property::Float then :float
            when ::DataMapper::Property::Integer then ::Integer
            # when ::DataMapper::Property::Numeric then :float
            # when ::DataMapper::Property::Object then :text
            # when ::DataMapper::Property::Serial then :serial
            # when ::DataMapper::Property::String then :string
            # when ::DataMapper::Property::Text then :text
            # when ::DataMapper::Property::Time then :time
            # else :text
            else type
            end
          end
        end
      end
    end
  end
end