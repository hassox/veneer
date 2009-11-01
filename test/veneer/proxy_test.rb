require File.join(File.dirname(__FILE__), "..", "test_helper")

class VeneerProxyTest < Test::Unit::TestCase
  context "Veneer::Proxy" do
    setup do
      clear_constants! :Foo, :Bar

      class ::Foo
        attr_accessor :order_field1, :order_field2, :name

        def self.collection
          @collection ||= []
        end

        def initialize(opts = {})
          @opts = opts
          [:order_field1, :order_field2, :name].each do |f|
            send(:"#{f}=", opts[f])
          end
          self.class.collection << self
        end

        def save
          @opts[:invalid].nil?
        end

        def save!
          raise Veneer::Errors::NotSaved if @opts[:invalid]
          true
        end


        module VeneerInterface
          class ClassWrapper < Veneer::Base::ClassWrapper
            def new(opts)
              ::Kernel.Veneer(klass.new(opts))
            end

            def find_first(conditional)
              ::Foo.collection.first
            end

            def find_many(conditional)
              result = ::Foo.collection

              unless conditional.order.empty?
                order = conditional.order.first
                result = result.sort_by{|i| i.send(order.field)}
                result.reverse! if order.ascending?
              end

              if conditional.offset
                offset = conditional.offset.to_i
                result = result[offset..-1]
              end

              conditional.conditions.each do |condition|
                filtered = case condition.operator
                when :eql
                  result.select{|i| i.send(condition.field) == condition.value}
                when :not
                  result.select{|i| i.send(condition.field) != condition.value}
                when :gt
                  result.select{|i| !i.send(condition.field).nil? && (i.send(condition.field) > condition.value)}
                when :gte
                  result.select{|i| !i.send(condition.field).nil? && (i.send(condition.field) >= condition.value)}
                when :lt
                  result.select{|i| !i.send(condition.field).nil? && (i.send(condition.field) < condition.value)}
                when :lte
                  result.select{|i| !i.send(condition.field).nil? && (i.send(condition.field) <= condition.value)}
                when :in
                  result.select{|i| condition.value.include?(i.send(condition.field))}
                else
                  []
                end
                result = filtered.flatten.compact
              end
              if conditional.limit
                result = result[0..(conditional.limit - 1)]
              end
              result
            end
          end

          class InstanceWrapper < Veneer::Base::InstanceWrapper
            def save!
              r = instance.save
              raise Veneer::Errors::NotSaved unless r
              r
            end

            def save
              instance.save
            rescue
              false
            end
          end
        end
      end
    end # setup

    should "be a BasicObject" do
      assert_equal Veneer::Proxy.ancestors[1], BasicObject
    end

    context "constants" do
      setup do
        @klass = ::Foo
        @valid_attributes   = {:name    => "foo"}
        @invalid_attributes = {:invalid => true}
        @instance           = ::Foo.new
      end

      veneer_should_have_the_required_veneer_constants
      veneer_should_implement_create_with_valid_attributes
      veneer_should_implement_create_with_invalid_attributes
      veneer_should_implement_find
    end
  end


end
