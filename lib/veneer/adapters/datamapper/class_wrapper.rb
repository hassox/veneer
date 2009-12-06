module DataMapper
  module Resource
    module VeneerInterface
      class ClassWrapper < ::Veneer::Base::ClassWrapper
        def new(opts = {})
          ::Kernel.Veneer(klass.new(opts))
        end

        def destroy_all
          klass.all.destroy
        end

        def find_first(conditional)
          opts = opts_from_conditional_for_dm(conditional)
          klass.first(opts)
        end

        def find_many(conditional)
          opts = opts_from_conditional_for_dm(conditional)
          klass.all(opts)
        end

        def before_save(*methods)
          klass.class_eval do
            methods.each do |meth|
              before :save, meth
            end
          end
        end

        [
          %w(validates_presence_of      validates_present),
          %w(validates_uniqueness_of    validates_is_unique),
          %w(validates_confirmation_of  validates_is_confirmed),
          %w(validates_with_method      validates_with_method)
        ].each do |(meth,natural)|
          class_eval <<-RUBY
            def #{meth}(*args)
              ensure_validations_loaded!
              klass.#{natural}(*args)
            end
          RUBY
        end

        private
        def ensure_validations_loaded!
          unless defined?(::DataMapper::Validate)
            ::Kernel.require 'dm-validations'
          end
        end

        def opts_from_conditional_for_dm(c)
          opts = {}

          opts[:limit]  = c.limit  if c.limit
          opts[:offset] = c.offset if c.offset

          unless c.order.empty?
            opts[:order] = c.order.inject([]) do |ary, cnd|
              ary << cnd.field.send(cnd.direction)
              ary
            end
          end

          unless c.conditions.empty?
            c.conditions.each do |cd|
              case cd.operator
              when :eql
                opts[cd.field] = cd.value
              when :not, :gt, :gte, :lt, :lte
                opts[cd.field.send(cd.operator)] = cd.value
              when :in
                opts[cd.field] = ::Array.new([cd.value].flatten.compact)
              end
            end
          end
          opts
        end
      end
    end
  end
end
