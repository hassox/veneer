module ActiveRecord
  class Base
    module VeneerInterface
      class ClassWrapper < Veneer::Base::ClassWrapper
        delegate :validators_on, :to => :klass 

        def self.except_classes
          @@except_classes ||= [
            "CGI::Session::ActiveRecordStore::Session",
            "ActiveRecord::SessionStore::Session"
          ]
        end

        def self.model_classes
          klasses = ::ActiveRecord::Base.descendants
          klasses.select do |klass|
            !klass.abstract_class? && !except_classes.include?(klass.name)
          end
        end

        def new(opts = {})
          ::Kernel::Veneer(klass.new(opts))
        end

        def collection_associations
          @collection_associations ||= begin
            associations = []
            [:has_many, :has_and_belongs_to_many].each do |macro|
              associations += klass.reflect_on_all_associations(macro)
            end
            associations.inject([]) do |ary, reflection|
              ary << {
                :name  => reflection.name,
                :class => reflection.class_name.constantize
              }
              ary
            end
          end
        end

        def member_associations
          @member_associations ||= begin
            associations = []
            [:belongs_to, :has_one].each do |macro|
              associations += klass.reflect_on_all_associations(macro)
            end
            associations.inject([]) do |ary, reflection|
              ary << {
                :name  => reflection.name,
                :class => reflection.class_name.constantize
              }
              ary
            end
          end
        end

        def properties
          @properties ||= begin
            klass.columns.map do |property|
              name = property.name.to_sym
             ::ActiveRecord::Base::VeneerInterface::Property.new(
                self,
                {
                  :name => name,
                  :type => property.type,
                  :constraints => {
                    :length => property.limit,
                    :nullable? => property.null,
                    :precision => property.precision,
                    :scale => property.scale,
                  },
                  :primary => primary_keys.include?(name),
                }
              )
            end
          end
        end

        def primary_keys
          @primary_keys ||= [klass.primary_key.to_sym]
        end

        def destroy_all
          klass.destroy_all
        end

        def find_first(opts)
          build_query(opts).first
        end

        def find_many(opts)
          build_query(opts).all
        end

        def count(opts ={})
          opts = ::Hashie::Mash.new(opts)
          build_query(opts).count
        end

        def sum(field, opts={})
          opts = ::Hashie::Mash.new(opts)
          build_query(opts).sum(field)
        end

        def max(field, opts={})
          opts = ::Hashie::Mash.new(opts)
          build_query(opts).maximum(field)
        end

        def min(field, opts={})
          opts = ::Hashie::Mash.new(opts)
          build_query(opts).minimum(field)
        end

        private
        def build_query(opts)
          query = klass
          query = query.where(opts.conditions.to_hash) if opts.conditions.present?
          query = query.limit(opts.limit.to_i)         if opts.limit?
          query = query.offset(opts.offset.to_i)       if opts.offset?
          query = query.order(opts.order)              if opts.order?
          query
        end
      end # ClassWrapper
    end
  end
end
