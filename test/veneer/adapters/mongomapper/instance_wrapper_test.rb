require File.join(File.dirname(__FILE__), "..", "..", "..", "test_helper")
require File.join(File.dirname(__FILE__), "mongomapper_setup")

module Veneer
  module Test
    class MongoMapperInstanceWrapper < ::Test::Unit::TestCase
      context "MongoMapper Veneer Adapter" do
        setup do
          @klass = MongoFoo
          @valid_attributes   = {:name => "foo", :password => "pass", :password_confirmation => "pass"}
          @invalid_attributes = @valid_attributes.dup.merge(:name => "invalid")
        end

        veneer_should_implement_new_record?
        veneer_should_implement_save
        veneer_should_implement_save!
        veneer_should_implement_destroy
      end
    end
  end
end
