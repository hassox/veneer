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
          klass.find(:first, opts.to_hash.symbolize_keys)
        end

        def find_many(opts)
          klass.find(:all,opts.to_hash.symbolize_keys)
        end
      end # ClassWrapper

    end
  end
end
