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

            def find_many(opts)
              result = ::Foo.collection.dup

              case opts.order
              when Array # first order only supported
                item = opts.order.first
                field, direction = item.split(" ")
                result = result.sort_by{|i| i.send(field)}
                result.reverse! if direction.to_s /desc/i
              when String, Symbol
                result = result.sort_by{|i| i.send(opts.order) }
              end

              if opts.offset?
                offset = opts.offset.to_i
                result = result[offset..-1]
              end

              if opts.conditions?
                opts.conditions.each do |field, value|
                  result = result.select{|i| i.send(field) == value}.flatten.compact
                end
              end

              if opts.limit?
                result = result[0..(opts.limit.to_i - 1)]
              end
              result
            end
          end

          class InstanceWrapper < Veneer::Base::InstanceWrapper
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

      should "get the correct resource" do
        expected = ::Foo.collection.select{|i| i.name == "foo1"}.first
        result = Veneer(::Foo).first(:conditions => {:name => "foo1"})
        assert_equal expected, result.instance
      end
    end
  end
end
