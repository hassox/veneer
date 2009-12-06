require File.join(File.dirname(__FILE__), "..", "test_helper")

class VeneerProxyTest < Test::Unit::TestCase
  context "Veneer::Proxy" do
    setup do
      clear_constants! :Foo, :Bar

      class ::Foo
        attr_accessor :order_field1, :order_field2, :name
        def self.veneer_spec_reset!
          collection.clear
        end

        def self.collection
          @collection ||= []
        end

        def initialize(opts = {})
          @opts = opts
          [:order_field1, :order_field2, :name].each do |f|
            send(:"#{f}=", opts[f])
          end
          self.class.collection << self
          @new_record = true
        end

        def new_record?
          !!@new_record
        end

        def save
          result = @opts[:invalid].nil?
          @new_record = false if result
          result
        end

        def save!
          raise Veneer::Errors::NotSaved if @opts[:invalid]
          @new_record = false
          true
        end


        module VeneerInterface
          class ClassWrapper < Veneer::Base::ClassWrapper
            def new(opts)
              ::Kernel.Veneer(klass.new(opts))
            end

            def destroy_all
              klass.collection.clear
            end

            def find_first(conditional)
              find_many(conditional).first
            end

            def find_many(conditional)
              result = ::Foo.collection

              unless conditional.order.empty?
                order = conditional.order.first
                result = result.sort_by{|i| i.send(order.field)}
                result.reverse! if order.decending?
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

            def new_record?
              instance.new_record?
            end

            def save!
              instance.save!
            end

            def save
              instance.save
            rescue
              false
            end

            def destroy
              instance.class.collection.delete(instance)
              self
            end
          end
        end
      end
    end # setup

    should "be a BasicObject" do
      assert_equal Veneer::Proxy.ancestors[1], BasicObject
    end

    context "test implementation" do
      setup do
        @klass = ::Foo
        @valid_attributes   = {:name    => "foo"}
        @invalid_attributes = {:invalid => true}
        @instance           = ::Foo.new
      end
    end

    context "all" do
      setup do
        ::Foo.collection.clear
        (0..5).each do |i|
          ::Foo.new(:name => "foo#{i}", :order_field1 => i)
        end
      end

      teardown{ ::Foo.collection.clear }

      should "get all the resources" do
        assert_equal ::Foo.collection.size, Veneer(::Foo).all.size
      end

      should "get the resources with a condition" do
        assert_equal 1, Veneer(::Foo).all(:conditions => {:name => "foo1"}).size
      end

      should "get the resources with offset, limit" do
        result = Veneer(::Foo).all(:offset => 1, :limit => 3)
        assert_equal 3, result.size
      end
    end

    context "first" do
      setup do
        ::Foo.collection.clear
        (0..5).each do |i|
          ::Foo.new(:name => "foo#{i}", :order_field1 => i)
        end
      end

      teardown{ ::Foo.collection.clear }

      should "get the correct resource with equal" do
        expected = ::Foo.collection.select{|i| i.name == "foo1"}.first
        result = Veneer(::Foo).first(:conditions => {:name => "foo1"})
        assert_equal expected, result.instance
      end
    end
  end
end
