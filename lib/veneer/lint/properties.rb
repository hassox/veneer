module Veneer
  module Lint
    module Properties
      include Veneer::Lint::Base
      
      def test_should_setup_properties_mapping
        assert_not_nil @properties_mapping
        assert_kind_of Hash, @properties_mapping
        @properties_mapping.each do |k, v|
          assert_kind_of Symbol, k
          assert_kind_of Class, v
        end
      end
      
      def test_should_setup_expected_primary_keys
        assert_not_nil @primary_keys
        assert_kind_of Array, @primary_keys
      end
      
      def test_properties
        result = Veneer(@klass).properties
        assert result.kind_of?(Array)
        assert result.size > 0
        property = result.first
        assert_kind_of Veneer::Base::Property, property
        assert_kind_of Class, property.type
        assert_kind_of Symbol, property.name
        assert_not_nil property.primary?
      end
      
      def test_primary_keys
        wrapped = Veneer(@klass)
        properties = wrapped.properties
        primary_keys = wrapped.primary_keys
        
        assert_equal @primary_keys, wrapped.primary_keys


        desired_primary_keys = properties.select { |property| primary_keys.include? property.name }
        assert_equal primary_keys.size, desired_primary_keys.size
        
        desired_primary_keys.each { |key| assert key.primary? }
      end

      def test_constraints
        Veneer(@klass).properties.each do |property|
          assert_not_nil property[:constraints]
        end
      end
      
      def test_length
        @properties_with_length.each do |name, length|
          assert_equal length, property_by_name(name).constraints[:length], "Expected #{name}.length to be #{length}."
        end
      end

      def test_types_conversion
        @properties_mapping.each do |name, expected_normalized_type|
          assert_equal expected_normalized_type, property_by_name(name).type, "Expected #{name} to be #{expected_normalized_type}."
        end
      end

      def test_validations
        @properties_with_validations.each do |name, validator_classes|
          validators = Veneer(@klass).validators_on(name)
          assert_equal validator_classes.size, validators.size
          validators.zip(validator_classes).each do |validator, expected_class|
            assert_kind_of expected_class, validator
          end
        end
      end

      def property_by_name(name)
        Veneer(@klass).properties.find { |prop| prop.name == name } or raise "Couldn't find property #{name}."
      end
    end
  end
end
