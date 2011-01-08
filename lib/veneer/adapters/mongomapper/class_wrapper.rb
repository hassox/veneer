module MongoMapper
  module Document
    module VeneerInterface
      class ClassWrapper < Veneer::Base::ClassWrapper
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

        def destroy_all
          klass.destroy_all
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
