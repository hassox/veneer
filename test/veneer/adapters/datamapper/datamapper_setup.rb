require 'dm-core'
require 'dm-validations'
require 'veneer/adapters/datamapper'

DataMapper.setup(:default, 'sqlite3::memory:')

class DMFoo
  include DataMapper::Resource

  property :id,           Serial
  property :name,         String
  property :order_field1, Integer

  validates_with_method :name, :method => :check_name

  def check_name
    if name == "invalid"
      [false, "Invalid name"]
    else
      true
    end
  end
end

DataMapper.auto_migrate!
