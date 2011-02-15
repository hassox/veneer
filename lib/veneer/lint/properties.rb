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
        # assert_not_nil hash.name
        assert_kind_of Class, property.type
        assert_kind_of Symbol, property.name
        assert_not_nil property.primary?
        # assert hash.has_key?(:length)
      end
      
      def test_primary_keys
        wrapped = Veneer(@klass)
        properties = wrapped.properties
        primary_keys = wrapped.primary_keys
        
        assert_equal @primary_keys, wrapped.primary_keys


        desired_primary_keys = properties.select { |property| primary_keys.include? property.name }
        assert_equal primary_keys.size, desired_primary_keys.size
        
        desired_primary_keys.each { |key| assert key.primary?, "Every primary key should have key[:primary?] equal true." }
      end
      
      def test_types_conversion
        @properties_mapping.each do |name, expected_normalized_type|
          assert_equal expected_normalized_type, property_by_name(name)[:type], "Expected #{name} to be #{expected_normalized_type}."
        end
      end

      def property_by_name(name)
        Veneer(@klass).properties.find { |prop| prop[:name] == name } or raise "Couldn't find property #{name}."
      end
    end
  end
end
