module ActiveRecord
  class Base
    module VeneerInterface
      module Types
        def normalize(type)
          case type
          when :serial, :integer then Integer
          when :string, :text then String
          when :float then Float
          when :decimal then BigDecimal
          when :datetime then DateTime
          when :time then Time
          when :date then Date
          when :binary then StringIO
          when :boolean then TrueClass
          else type
          end
        end
      end
    end
  end
end
