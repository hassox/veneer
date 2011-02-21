module DataMapper
  module Resource
    module VeneerInterface
      module Types
        def normalize(type)
          # Several DataMapper properties' types inherit from the Object class
          # so DataMapper::Property::Object must be the last one i the case statement.
          case type
          when DataMapper::Property::Integer then Integer
          when DataMapper::Property::String then String
          when DataMapper::Property::Float then Float
          when DataMapper::Property::Decimal then BigDecimal  
          when DataMapper::Property::DateTime then DateTime  
          when DataMapper::Property::Time then Time
          when DataMapper::Property::Date then Date
          when DataMapper::Property::Boolean then TrueClass
          when DataMapper::Property::Discriminator then Class
          when DataMapper::Property::Object then Object
          else type
          end
        end
      end
    end
  end
end
