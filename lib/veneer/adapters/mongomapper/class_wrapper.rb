module MongoMapper
  module Document
    module VeneerInterface
      class ClassWrapper < Veneer::Base::ClassWrapper
        PRIMARY_KEYS = [:_id]
        
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
              property = property[1]
              name = property.name.to_sym
              ::Veneer::Base::Property.new(
                :name => name,
                :type => ::MongoMapper::Document::VeneerInterface::ClassWrapper::Types.normalize(property.type),
                :length => property.options[:length],
                :primary => primary_keys.include?(name)
              )
            end
          end
        end
        
        def primary_keys
          ::MongoMapper::Document::VeneerInterface::ClassWrapper::PRIMARY_KEYS
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
      end
    end
  end
end
