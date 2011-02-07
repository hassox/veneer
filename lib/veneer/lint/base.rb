module Veneer
  module Lint
    module Base
      def test_should_setup_the_veneer_lint_class_wrapper_with_a_klass
        assert_not_nil @klass, "@klass should provide a class to test Veneer with"
        assert_kind_of Class, @klass
      end
    end
  end
end