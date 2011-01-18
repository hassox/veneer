module DataMapper
  module Resource
    module VeneerInterface
      class ClassWrapper < ::Veneer::Base::ClassWrapper
        def self.model_classes
          ::DataMapper::Model.descendants
        end

        def new(opts = {})
          ::Kernel.Veneer(klass.new(opts))
        end

        def collection_associations
          @collection_associations ||= begin
            result = klass.relationships.inject([]) do |ary, (name, rel)|
              if rel.max > 1
                ary << {
                  :name  => name,
                  :class => rel.child_model
                }
              end
              ary
            end
            result
          end
        end

        def member_associations
          @member_associations ||= begin
            result = klass.relationships.inject([]) do |ary, (name, rel)|
              if rel.max == 1
                ary << {
                  :name  => name,
                  :class => rel.parent_model
                }
              end
              ary
            end
            result
          end
        end

        def properties
          @properties ||= begin
            klass.properties.map do |property|
              {
                :name => property.name,
                :type => dm_property_type(property),
                :length => property.options[:length],
              }
            end
          end
        end

        def destroy_all
          klass.all.destroy
        end

        def find_first(opts)
          klass.first(dm_conditions_from_opts(opts))
        end

        def find_many(opts)
          klass.all(dm_conditions_from_opts(opts)).to_a
        end

        def count(opts={})
          opts[:conditions].nil? ? klass.count : klass.count(opts[:conditions])
        end

        def sum(field, opts={})
          opts = ::Hashie::Mash.new(opts)
          klass.all(dm_conditions_from_opts(opts)).sum(field)
        end

        def min(field, opts={})
          opts = ::Hashie::Mash.new(opts)
          klass.all(dm_conditions_from_opts(opts)).min(field)
        end

        def max(field, opts={})
          opts = ::Hashie::Mash.new(opts)
          klass.all(dm_conditions_from_opts(opts)).max(field)
        end

        private
        def order_from_string(str)
          field, direction = str.split " "
          direction ||= "asc"
          field.to_sym.send(direction) if allowed_field?(field)
        end

        def allowed_field?(field)
          @allowed ||= klass.properties.map(&:name).map(&:to_s)
          @allowed.include?(field.to_s)
        end

        def dm_conditions_from_opts(raw)
          opts = {}

          opts[:limit]  = raw.limit  if raw.limit?
          opts[:offset] = raw.offset if raw.offset?

          if raw.order.present?
            opts[:order] = case raw.order
            when ::Array
              raw.order.inject([]) do |ary, str|
                ary << order_from_string(str)
              end.compact
            when ::String
              order_from_string(raw.order)
            when ::Symbol
              raw.order
            end
          end

          if raw.conditions.present?
            raw.conditions.each do |(field, value)|
              opts[field.to_sym] = value if allowed_field?(field)
            end
          end
          opts
        end

        def dm_property_type(property)
          case property
            when ::DataMapper::Property::Binary then :binary
            when ::DataMapper::Property::Boolean then :boolean
            when ::DataMapper::Property::Class then :string
            when ::DataMapper::Property::Date then :date
            when ::DataMapper::Property::DateTime then :datetime
            when ::DataMapper::Property::Decimal then :datetime
            when ::DataMapper::Property::Discriminator then :string
            when ::DataMapper::Property::Float then :float
            when ::DataMapper::Property::Integer then :integer
            when ::DataMapper::Property::Numeric then :float
            when ::DataMapper::Property::Object then :text
            when ::DataMapper::Property::Serial then :serial
            when ::DataMapper::Property::String then :string
            when ::DataMapper::Property::Text then :text
            when ::DataMapper::Property::Time then :time
            else :text
          end
        end
      end
    end
  end
end
