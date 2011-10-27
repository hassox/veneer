module MongoMapper
  module Document
    module VeneerInterface
      class ClassWrapper < Veneer::Base::ClassWrapper
        delegate :validators_on, :to => :klass

        PRIMARY_KEYS = [:_id]
        
        def self.model_classes
          ::MongoMapper::Document.descendants
        end

        def new(opts = {})
          ::Kernel::Veneer(klass.new(opts))
        end

        def collection_associations
          @collection_associations ||= begin
            klass.associations.inject([]) do |ary, (name, assoc)|
              if assoc.is_a? ::MongoMapper::Plugins::Associations::ManyAssociation
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
            types = [::MongoMapper::Plugins::Associations::BelongsToAssociation,
                     ::MongoMapper::Plugins::Associations::ManyAssociation]
            klass.associations.inject([]) do |ary, (name, assoc)|
              if types.include?(assoc.class)
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
              ::MongoMapper::Document::VeneerInterface::Property.new(
                self,
                {
                  :name => name,
                  :type => property.type,
                  :constraints => {
                    :length => property.options[:length],
                    :nullable? => nil,
                    :precision => nil,
                  },
                  :primary => primary_keys.include?(name),
                }
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
