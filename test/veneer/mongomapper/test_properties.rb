require File.expand_path(File.join(File.dirname(__FILE__), '..', "..", "test_helper"))
require 'mongo_mapper'

require 'veneer/adapters/mongomapper'

MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017)
MongoMapper.database = 'veneer_test'

class MongoBar
  include MongoMapper::Document

  key :name,          String
  key :string_field,  String
  key :integer_field, Integer
  key :float_field,   Float
  key :date_field,    Date
  key :boolean_field, Boolean
  key :hash_field,    Hash
  key :set_field,     Set
  key :time_field,    Time
  key :object_field,  Object
  key :binary_field,  Binary
end


class MongoMapperPropertiesTest < ::Test::Unit::TestCase
  include Veneer::Lint::Properties

  def setup
    @klass              = ::MongoBar
    @properties_mapping = {
      :_id => String, #ObjectID
      :string_field => String,
      :integer_field => Integer,
      :float_field => Float,
      :date_field => Date,
      :boolean_field => TrueClass, 
      :hash_field => Hash,
      :set_field => Set,
      :time_field => Time,
      :object_field => Object,
      :binary_field => StringIO
    }
  end
end