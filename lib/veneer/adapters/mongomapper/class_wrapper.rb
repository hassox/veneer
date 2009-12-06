module MongoMapper
  module Document
    module VeneerInterface
      class ClassWrapper < Veneer::Base::ClassWrapper
        def new(opts = {})
          ::Kernel::Veneer(klass.new(opts))
        end

        def destroy_all
          klass.destroy_all
        end

        def find_first(conditional)
          opts = conditional_to_mongo_opts(conditional)
          klass.first(opts)
        end

        def find_many(conditional)
          opts = conditional_to_mongo_opts(conditional)
          klass.all(opts)
        end

        def before_save(*methods)
          klass.before_save *methods
        end

        %w(
          validates_presence_of
          validates_uniqueness_of
          validates_confirmation_of
        ).each do |meth|
          class_eval <<-RUBY
            def #{meth}(*args)
              klass.#{meth}(*args)
            end
          RUBY
        end

        def validates_with_method(*methods)
          methods.each do |meth|
            klass.validates_each(nil, :logic => ::Proc.new{ send(meth)})
          end
        end

        private
        def conditional_to_mongo_opts(c)
          opts = {}
          opts[:limit]  = c.limit if c.limit
          opts[:offset] = c.offset if c.offset

          unless c.order.blank?
            opts[:order] = c.order.inject([]) do |ary, cnd|
              ary << "#{cnd.field} #{cnd.direction}"
            end.join(",")
          end

          unless c.conditions.blank?
            cnds = c.conditions.inject({}) do |hsh, c|
              case c.operator
              when :eql
                hsh[c.field] = c.value
              when :not
                hsh[c.field] = {"$ne" => c.value}
              when :gt, :gte, :lt, :lte, :in
                hsh[c.field] = {"$#{c.operator}" => c.value}
              end
              ::STDOUT.puts hsh.inspect
              hsh
            end
            opts[:conditions] = cnds
          end
          opts
        end
      end
    end
  end
end
