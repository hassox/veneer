module Veneer
  module Lint
    module Properties
      def test_should_setup_the_veneer_lint_class_wrapper_with_a_klass
        assert_not_nil @klass, "@klass should provide a class to test Veneer with"
        assert_kind_of Class, @klass
      end
      
      def test_should_setup_properties_mapping
        assert_not_nil @properties_mapping
        assert_kind_of Hash, @properties_mapping
        @properties_mapping.each do |k, v|
          assert_kind_of Symbol, k
          assert_kind_of Class, v
        end
      end
      
      def test_properties
        result = Veneer(@klass).properties
        assert result.kind_of?(Array)
        assert result.size > 0
        hash = result.first
        assert hash.kind_of?(Hash)
        assert_not_nil hash[:name]
        assert_not_nil hash[:type]
        assert_kind_of Symbol, hash[:name]
        assert hash.has_key?(:length)
      end
    
      def test_types_conversion
        @properties_mapping.each do |name, expected_normalized_type|
          assert_equal expected_normalized_type, property_by_name(name)[:type]
        end
      end

      def property_by_name(name)
        Veneer(@klass).properties.find { |prop| prop[:name] == name } or raise "Couldn't find property #{name}"
      end
    end
  end
end
