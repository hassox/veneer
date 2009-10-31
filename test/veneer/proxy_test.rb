require File.join(File.dirname(__FILE__), "..", "test_helper")

class VeneerProxyTest < Test::Unit::TestCase
  context "Veneer::Proxy" do
    setup do
      clear_constants! :Foo, :Bar

      class ::Foo
        def initialize(opts = {})
          @opts = opts
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
    end
  end


end
