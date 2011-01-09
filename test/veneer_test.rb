require File.join(File.dirname(__FILE__), "test_helper")

class VeneerTestCase < Test::Unit::TestCase
  context "Venner" do
    setup do
      clear_constants! :Foo, :Bar
      Veneer::Base::ClassWrapper.subclasses.clear
    end

    should "keep track of all class wrappers" do
      assert_equal 0, Veneer::Base::ClassWrapper.subclasses.size
      class ::Foo < Veneer::Base::ClassWrapper; end
      assert_equal 1, Veneer::Base::ClassWrapper.subclasses.size
      assert_equal Veneer::Base::ClassWrapper.subclasses.first, ::Foo
    end

    should "defer to the adapters class_models to gather all class models" do
      class ::Foo < Veneer::Base::ClassWrapper
        def self.model_classes
          [:foo_models]
        end
      end

      class ::Bar < Veneer::Base::ClassWrapper
        def self.model_classes
          [:bar_models]
        end
      end

      result = Veneer.model_classes
      assert_equal result, [:foo_models, :bar_models]
    end
  end
end

