require File.join(File.dirname(__FILE__), "..", "..", "..", "test_helper")
require File.join(File.dirname(__FILE__), "datamapper_setup")

module Veneer
  module Test
    class DataMapperClassWrapper < ::Test::Unit::TestCase
      context "DataMapper Veneer Adapter" do
        setup do
          @klass = DMFoo
          @valid_attributes   = {:name => "foo", :password => "pass", :password_confirmation => "pass"}
          @invalid_attributes = @valid_attributes.dup.merge(:name => "invalid")
        end

        veneer_should_have_the_required_veneer_constants
        veneer_should_implement_create_with_valid_attributes
        veneer_should_impelement_destroy_all
        veneer_should_implement_create_with_invalid_attributes
        veneer_should_implement_find
        veneer_should_implement_before_save_hooks
        veneer_should_implement_validations
      end
    end
  end
end
