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
                :name => property[1].name.to_sym,
                :type => ::MongoMapper::Document::VeneerInterface::ClassWrapper::Types.normalize(property[1].type),
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
      end
    end
  end
end
