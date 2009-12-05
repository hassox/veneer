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

        def find_first(conditional)
          opts = conditional_to_ar_opts(conditional)
          klass.find(:first, opts)
        end

        def find_many(conditional)
          opts = conditional_to_ar_opts(conditional)
          klass.find(:all,opts)
        end

        private
        def conditional_to_ar_opts(c)
          opts = {}
          opts[:limit]  = c.limit   if c.limit
          opts[:offset] = c.offset  if c.offset

          unless c.order.blank?
            opts[:order] = c.order.inject([]) do |ary, cnd|
              ary << "#{cnd.field} #{cnd.direction}"
            end.join(",")
          end

          unless c.conditions.blank?
            val_array = []
            cnds = c.conditions.inject([]) do |ary, cd|
              case cd.operator
              when :eql
                if cd.value.nil?
                  ary << "#{cd.field} IS ?"
                else
                  ary << "#{cd.field} = ?"
                end
                val_array << cd.value
              when :not
                if cd.value.nil?
                  ary << "#{cd.field} IS NOT ?"
                else
                  ary << "#{cd.field} <> ?"
                end
                val_array << cd.value
              when :gt
                ary << "#{cd.field} > ?"
                val_array << cd.value
              when :gte
                ary << "#{cd.field} >= ?"
                val_array << cd.value
              when :lt
                ary << "#{cd.field} < ?"
                val_array << cd.value
              when :lte
                ary << "#{cd.field} <= ?"
                val_array << cd.value
              when :in
                ary << "#{cd.field} IN ( ? )"
                val_array << cd.value
              end
              ary
            end
            opts[:conditions] = [cnds.join(" AND "), *val_array]
          end
          opts
        end
      end # ClassWrapper

    end
  end
end
