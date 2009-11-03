require File.join(File.dirname(__FILE__), "..", "..", "..", "test_helper")
require File.join(File.dirname(__FILE__), "active_record_setup")

module Veneer
  module Test
    class ActiveRecordInstanceWrapper < ::Test::Unit::TestCase
      context "Active Record Veneer Adapter" do
        setup do
          @klass              = ::ActiveRecordFoo
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
