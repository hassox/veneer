module ActiveRecord
  class Base
    module VeneerInterface
      class ClassWrapper < Veneer::Base::ClassWrapper
        def new(opts = {})
          ::Kernel::Veneer(klass.new(opts))
        end

        def destroy_all
          klass.destroy_all
        end

        def find_first(opts)
          build_query(opts).first
        end

        def find_many(opts)
          build_query(opts)
        end

        private
        def build_query(opts)
          query = klass
          query.where(opts.conditions) if opts.conditions.present?
          query.limit(opts.limit)      if opts.limit?
          query.offset(opts.offset)    if opts.offset?
          query.order(opts.order)      if opts.order?
          query
        end
      end # ClassWrapper
    end
  end
end
