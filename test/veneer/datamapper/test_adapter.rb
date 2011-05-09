require File.expand_path(File.join(File.dirname(__FILE__), '..', "..", "test_helper"))
require 'dm-core'
require 'dm-migrations'
require 'dm-aggregates'
require 'veneer/adapters/datamapper'

DataMapper.setup(:default, 'sqlite3::memory:')

class DMFoo
  include DataMapper::Resource
  include ActiveModel::Validations

  property :id,                  Serial
  property :name,                String
  property :title,               String
  property :description,         String
  property :integer_field,       Integer, :required => false
  property :order_field1,        Integer
  property :item_id,             Integer, :required => false
  property :text_field,          Text
  property :float_field,         Float
  property :decimal_field,       Decimal
  property :datetime_field,      DateTime
  property :time_field,          Time
  property :date_field,          Date
  property :boolean_field,       Boolean
  property :object_field,        Object
  property :discriminator_field, Discriminator
  
  validate :check_name

  has n,      :items,  self, :child_key => [:item_id]
  belongs_to  :master, self, :child_key => [:item_id]

  before :save do
    throw :halt unless valid?
  end

  def check_name
    errors.add(:base, "Invalid name") if name == "invalid"
  end

  def v_with_m_test
    if name == "v_with_m_test"
      [false, "name cannot be v_with_m_test"]
    else
      true
    end
  end
end

DataMapper.auto_migrate!

class DataMapperAdapterTest < ::Test::Unit::TestCase
  include Veneer::Lint::Adapter

  def setup
    @klass              = ::DMFoo
    @valid_attributes   = {:name => "foo", :title => "title", :description => "description", :integer_field => 1}
    @invalid_attributes = @valid_attributes.dup.merge(:name => "invalid")
  end

  def create_valid_items(num)
    attr = @valid_attributes

    (1..num).each do |i|
      DMFoo.create(:name => "#{attr[:name]}#{i}", :title => "#{attr[:title]}#{i}", :description => "#{attr[:description]}#{i}", :integer_field => 1)
    end
  end  
end

