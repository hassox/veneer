require File.expand_path(File.join(File.dirname(__FILE__), '..', "..", "test_helper"))

begin
  require 'active_record'
rescue LoadError
  require 'activerecord'
end

require 'veneer/adapters/activerecord'


Veneer::Test::ActiveRecordHelper.establish_connection

class CreateActiveRecordBar < ActiveRecord::Migration
  extend Veneer::Test::ActiveRecordHelper.migration
end

CreateActiveRecordBar.up

class ActiveRecordBar < ActiveRecord::Base; end

class ActiveRecordPropertiesTest < ::Test::Unit::TestCase
  include Veneer::Lint::Properties

  def setup
    @klass              = ::ActiveRecordBar
    @properties_mapping = {
      :id => Integer,
      :string_field => String,
      :text_field => String,
      :integer_field => Integer,
      :float_field => Float,
      :decimal_field => BigDecimal,
      :datetime_field => DateTime,
      :timestamp_field => DateTime,
      :time_field => Time,
      :date_field => Date,
      :binary_field => StringIO,
      :boolean_field => TrueClass
    }
    @primary_keys = [:id, :name]
  end
end