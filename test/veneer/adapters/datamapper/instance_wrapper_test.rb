require File.join(File.dirname(__FILE__), "..", "..", "..", "test_helper")
require File.join(File.dirname(__FILE__), "datamapper_setup")

module Veneer
  module Test
    class DataMapperInstanceWrapper < ::Test::Unit::TestCase
      context "DataMapper Veneer Adapter" do
        setup do
          @klass = DMFoo
          @valid_attributes   = {:name => "foo"}
          @invalid_attributes = {:name => "invalid"}
        end

        veneer_should_implement_new_record?
        veneer_should_implement_save
        veneer_should_implement_save!
        veneer_should_implement_destroy
      end
    end
  end
end
