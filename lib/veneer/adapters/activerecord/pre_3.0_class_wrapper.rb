module ActiveRecord
  class Base
    module VeneerInterface
      class ClassWrapper < Veneer::Base::ClassWrapper
        def self.except_classes
          @@except_classes ||= [
            "CGI::Session::ActiveRecordStore::Session",
            "ActiveRecord::SessionStore::Session"
          ]
        end

        def self.model_classes
          klasses = ::ActiveRecord::Base.__send__(:subclasses)
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

        def destroy_all
          klass.destroy_all
        end

        def find_first(opts)
          klass.find(:first, opts.to_hash.symbolize_keys)
        end

        def find_many(opts)
          klass.find(:all,opts.to_hash.symbolize_keys)
        end

        def count(opts={})
          if opts[:conditions]
            klass.count(:conditions => opts[:conditions])
          else
            klass.count
          end
        end

        def sum(field, opts={})
          if opts[:conditions]
            klass.sum(field, :conditions => opts[:conditions])
          else
            klass.sum(field)
          end
        end
      end # ClassWrapper
    end
  end
end
