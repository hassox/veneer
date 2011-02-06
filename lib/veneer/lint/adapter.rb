module Veneer
  module Lint
    module Adapter
      def self.included(base)
        base.class_eval do
          include ::Veneer::Lint::Adapter::ClassWrapperLint
          include ::Veneer::Lint::Adapter::InstanceWrapperLint
          # include ::Veneer::Lint::PropertiesLint
        end
      end

      def _veneer_teardown
        Veneer(@klass).destroy_all
      end

      module ClassWrapperLint
        def test_should_have_the_correct_inner_constants_for_veneer
          assert_nothing_raised do
            @klass::VeneerInterface
            @klass::VeneerInterface::ClassWrapper
            @klass::VeneerInterface::InstanceWrapper
          end
          assert @klass::VeneerInterface::ClassWrapper.ancestors.include?(::Veneer::Base::ClassWrapper)
          assert @klass::VeneerInterface::InstanceWrapper.ancestors.include?(::Veneer::Base::InstanceWrapper)
        end

        def test_should_setup_the_veneer_lint_class_wrapper_with_a_klass
          assert_not_nil @klass, "@klass should provide a class to test Veneer with"
          assert_kind_of Class, @klass
        ensure
          _veneer_teardown
        end

        def test_should_provide_valid_attributes
          assert_not_nil @valid_attributes
          assert_kind_of Hash, @valid_attributes
        ensure
          _veneer_teardown
        end

        def test_should_provide_invalid_attributes
          assert_not_nil @invalid_attributes
          assert_kind_of Hash, @invalid_attributes
        ensure
          _veneer_teardown
        end

        def test_should_create_an_object_from_a_hash
          r = Veneer(@klass).create(@valid_attributes)
          assert_instance_of @klass::VeneerInterface::InstanceWrapper, r
        ensure
          _veneer_teardown
        end

        def test_should_create_the_object_from_the_hash_with_create!
          r = Veneer(@klass).create!(@valid_attributes)
          assert_instance_of @klass::VeneerInterface::InstanceWrapper, r
        ensure
          _veneer_teardown
        end

        def test_should_instantiate_a_new_instance_of_the_object
          r = Veneer(@klass).new(@valid_attributes)
          assert_instance_of @klass::VeneerInterface::InstanceWrapper, r
        ensure
          _veneer_teardown
        end

        def test_implementst_create_with_invalid_attributes
          assert_raise Veneer::Errors::NotSaved do
            Veneer(@klass).create!(@invalid_attributes)
          end
        ensure
          _veneer_teardown
        end

        def test_should_not_raise_when_create_can_save
          assert_nothing_raised do
            Veneer(@klass).create(@invalid_attributes)
          end
        ensure
          _veneer_teardown
        end

        def test_should_destory_all
          Veneer(@klass).create(@valid_attributes)
          assert Veneer(@klass).all.size > 0
          Veneer(@klass).destroy_all
          assert_equal 0, Veneer(@klass).all.size
        end

        def test_should_find_all
          create_valid_items(4)
          result = Veneer(@klass).all
          assert_kind_of Array, result
          assert_equal 4, result.size
        ensure
          _veneer_teardown
        end

        def test_should_find_first
          create_valid_items(3)
          result = Veneer(@klass).all
          assert_not_nil result
        ensure
          _veneer_teardown
        end

        def test_should_implement_limit
          create_valid_items(4)
          result = Veneer(@klass).all(:limit => 2)
          assert_equal 2, result.size
        ensure
          _veneer_teardown
        end

        def test_should_implement_order
          create_valid_items(4)
          key = @valid_attributes.keys.first
          ordered_result = Veneer(@klass).all(:order => key)
          result = Veneer(@klass).all
          result = result.sort_by{ |i| i.send(key) }
          assert_equal ordered_result, result
        ensure
          _veneer_teardown
        end

        def test_should_implement_order_with_desc
          create_valid_items(4)
          ordered_result = Veneer(@klass).all(:order => "name desc")
          result = Veneer(@klass).all
          result = result.sort_by{ |i| i.name }.reverse
          assert_equal ordered_result, result
        ensure
          _veneer_teardown
        end

        def test_should_implement_offset
          create_valid_items(4)
          result = Veneer(@klass).all
          offset_result = Veneer(@klass).all(:offset => 2, :limit => 2)
          assert_equal result[2..4], offset_result
        ensure
          _veneer_teardown
        end

        def test_conditions
          create_valid_items(3)
          Veneer(@klass).create(@valid_attributes)
          result = Veneer(@klass).all(:conditions => @valid_attributes)
          assert_equal 1, result.size
        ensure
          _veneer_teardown
        end

        def test_collection_associations
          result = Veneer(@klass).collection_associations
          assert result.kind_of?(Array)
          assert result.size > 0
          hash = result.first
          assert hash.kind_of?(Hash)
          assert_not_nil hash[:name]
          assert_not_nil hash[:class]
        end

        def test_member_associations
          result = Veneer(@klass).member_associations
          assert result.kind_of?(Array)
          assert result.size > 0
          hash = result.first
          assert hash.kind_of?(Hash)
          assert_not_nil hash[:name]
          assert_not_nil hash[:class]
        end
      end

      module InstanceWrapperLint
        def test_should_implement_destroy
          item = Veneer(@klass).create(@valid_attributes)
          assert Veneer(@klass).all.size > 0
          assert item.kind_of?(Veneer::Base::InstanceWrapper)
          item.destroy
          assert Veneer(@klass).all.size == 0
        ensure
          _veneer_teardown
        end

        def test_should_implement_new_record?
          item = Veneer(@klass).new(@valid_attributes)
          assert item.new_record?
          assert item.save
          assert !item.new_record?
        ensure
          _veneer_teardown
        end

        def test_should_implement_save!
          assert_raises Veneer::Errors::NotSaved do
            Veneer(@klass).create!(@invalid_attributes)
          end
        end

        def test_should_list_model_classes
          assert Veneer.model_classes.size > 0
        end

        #### Aggregations
        def test_should_implement_count_without_arguments
          create_valid_items(3)
          assert_equal 3, Veneer(@klass).count
        ensure
          _veneer_teardown
        end

        def test_should_implement_count_with_arguments
          create_valid_items(3)
          Veneer(@klass).create(@valid_attributes)
          assert_equal 1, Veneer(@klass).count(:conditions => @valid_attributes)
        ensure
          _veneer_teardown
        end

        def test_should_implement_sum_without_arguments
          create_valid_items(3)
          results = Veneer(@klass).all
          results.inject(0){ |sum, i| (i.send(:integer_field) ||0) + sum }
          assert_equal 3, Veneer(@klass).sum(:integer_field)
        ensure
          _veneer_teardown
        end

        def test_should_implement_sum_with_arguments
          create_valid_items(3)
          Veneer(@klass).create(@valid_attributes)
          results = Veneer(@klass).all(:conditions => @valid_attributes)
          results.inject(0){ |sum, i| (i.send(:integer_field) ||0) + sum }
          assert_equal 1, Veneer(@klass).sum(:integer_field, :conditions => @valid_attributes)
        ensure
          _veneer_teardown
        end

        def test_should_implement_min_without_arguments
          create_valid_items(3)
          Veneer(@klass).create(@valid_attributes.merge(:integer_field => -5))
          results = Veneer(@klass).all
          assert_equal(-5, Veneer(@klass).min(:integer_field))
        ensure
          _veneer_teardown
        end

        def test_should_implement_min_with_arguments
          create_valid_items(3)
          attrs = @valid_attributes.merge(:integer_field => -5)
          Veneer(@klass).create(attrs)
          results = Veneer(@klass).all(:conditions => attrs)
          assert_equal(-5, Veneer(@klass).min(:integer_field))
        ensure
          _veneer_teardown
        end

        def test_should_implement_max_without_arguments
          create_valid_items(3)
          Veneer(@klass).create(@valid_attributes.merge(:integer_field => 99999))
          results = Veneer(@klass).all
          assert_equal 99999, Veneer(@klass).max(:integer_field)
        ensure
          _veneer_teardown
        end

        def test_should_implement_max_with_arguments
          create_valid_items(3)
          attrs = @valid_attributes.merge(:integer_field => 99999)
          Veneer(@klass).create(attrs)
          results = Veneer(@klass).all(:conditions => attrs)
          assert_equal 99999, Veneer(@klass).max(:integer_field)
        ensure
          _veneer_teardown
        end
      end
    end
  end
end
