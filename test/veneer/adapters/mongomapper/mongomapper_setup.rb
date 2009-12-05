require 'mongomapper'

require 'veneer/adapters/mongomapper'

MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017)
MongoMapper.database = 'veneer_test'

class MongoFoo
  include MongoMapper::Document

  key :name,          String
  key :order_field1,  Integer

  validate_on_create :check_name

  def check_name
    errors.add(:name, "may not be invalid") if name == "invalid"
  end
end

