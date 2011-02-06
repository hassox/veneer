require File.expand_path(File.join(File.dirname(__FILE__), '..', "..", "test_helper"))
require 'dm-core'
require 'dm-migrations'
require 'veneer/adapters/datamapper'

DataMapper.setup(:default, 'sqlite3::memory:')

class DMBar
  include DataMapper::Resource
  
  property :id,                  Serial, :key => true
  property :another_id,          Integer, :key => true
  property :string_field,        String
  property :integer_field,       Integer
  property :text_field,          Text
  property :float_field,         Float
  property :decimal_field,       Decimal
  property :datetime_field,      DateTime
  property :time_field,          Time
  property :date_field,          Date
  property :boolean_field,       Boolean
  property :object_field,        Object
  property :discriminator_field, Discriminator
end

DataMapper.auto_migrate!

class DataMapperPropertiesTest < ::Test::Unit::TestCase
  include Veneer::Lint::Properties

  def setup
    @klass              = ::DMBar
    @properties_mapping = {
      :id => Integer, #Serial,             
      :string_field => String,
      :text_field => String,
      :integer_field => Integer,
      :float_field => Float,
      :decimal_field => BigDecimal,
      :datetime_field => DateTime,
      :time_field => Time,
      :date_field => Date,
      :boolean_field => TrueClass,
      :object_field => Object,
      :discriminator_field => Class
    }
  end
end