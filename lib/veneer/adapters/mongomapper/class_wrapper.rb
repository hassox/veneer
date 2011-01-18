module MongoMapper
  module Document
    module VeneerInterface
      class ClassWrapper < Veneer::Base::ClassWrapper
        def self.model_classes
          ::MongoMapper::Document.descendants
        end

        def new(opts = {})
          ::Kernel::Veneer(klass.new(opts))
        end

        def collection_associations
          @collection_associations ||= begin
            types = [:many]
            klass.associations.inject([]) do |ary, (name, assoc)|
              if types.include?(assoc.type)
                ary << {
                  :name => name,
                  :class => assoc.class_name.constantize
                }
              end
              ary
            end
          end
        end

        def member_associations
          @member_associations ||= begin
            types = [:belongs_to, :one]
            klass.associations.inject([]) do |ary, (name, assoc)|
              if types.include?(assoc.type)
                ary << {
                  :name => name,
                  :class => assoc.class_name.constantize
                }
              end
              ary
            end
          end
        end

        def properties
          @properties ||= begin
            klass.keys.map do |property|
              {
                :name => property[1].name,
                :type => mm_property_type(property[1].type),
                :length => property[1].options[:length],
              }
            end
          end
        end

        def destroy_all
          klass.destroy_all
        end

        def count(opts={})
          opts[:conditions].nil? ? klass.count : klass.count(opts[:conditions])
        end

        def find_first(opts)
          klass.first(opts)
        end

        def find_many(opts)
          klass.all(opts)
        end

        private
        def mm_property_type(property)
          case property
            when ::MongoMapper::Extensions::Array then :serialized
            when ::MongoMapper::Extensions::Binary then :binary
            when ::MongoMapper::Extensions::Boolean then :boolean
            when ::MongoMapper::Extensions::Date then :date
            when ::MongoMapper::Extensions::Float then :float
            when ::MongoMapper::Extensions::Hash then :serialized
            when ::MongoMapper::Extensions::Integer then :integer
            when ::MongoMapper::Extensions::NilClass then :serialized
            when ::MongoMapper::Extensions::Object then :serialized
            when ::MongoMapper::Extensions::ObjectId then :serial
            when ::MongoMapper::Extensions::Set then :serialized
            when ::MongoMapper::Extensions::String then :string
            when ::MongoMapper::Extensions::Time then :time
          end
        end
      end
    end
  end
end
