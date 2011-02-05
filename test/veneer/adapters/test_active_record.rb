require File.expand_path(File.join(File.dirname(__FILE__), '..', "..", "test_helper"))

begin
  require 'active_record'
rescue LoadError
  require 'activerecord'
end

require 'veneer/adapters/activerecord'
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

class CreateActiveRecordFoo < ActiveRecord::Migration

  def self.up
    create_table :active_record_foos, :force => true do |t|
      t.string  :name
      t.string  :title
      t.string  :description
      t.integer :integer_field
      t.integer :order_field1
      t.integer :belonger_id
      t.text    :text_field
      t.float   :float_field
      t.decimal :decimal_field
      t.datetime :datetime_field
      t.timestamp :timestamp_field
      t.time      :time_field
      t.datetime :datetime_field
      t.date    :date_field
      t.binary  :binary_field
      t.boolean :boolean_field
    end
  end

  def self.down
    drop_table :active_record_foos
  end
end

CreateActiveRecordFoo.up

class ActiveRecordFoo < ActiveRecord::Base
  has_many :items, :class_name => "ActiveRecordFoo", :foreign_key => 'belonger_id'
  belongs_to :master, :class_name => "ActiveRecordFoo", :foreign_key => 'belonger_id'

  def self.veneer_spec_reset!
    delete_all
  end

  def validate
    errors.add(:name, "Name cannot be 'invalid'") if name == "invalid"
  end

  def v_with_m_test
    errors.add(:name, "Name cannot be v_with_m_test") if name == "v_with_m_test"
  end
end

class ActiveRecordVeneerTest < ::Test::Unit::TestCase
  include Veneer::Lint

  def setup
    @klass              = ::ActiveRecordFoo
    @valid_attributes   = {:name => "foo", :title => "title", :description => "description", :integer_field => 1}
    @invalid_attributes = @valid_attributes.dup.merge(:name => "invalid")
  end

  def create_valid_items(num)
    attr = @valid_attributes

    (1..num).each do |i|
      ActiveRecordFoo.create(:name => "#{attr[:name]}#{i}", :title => "#{attr[:title]}#{i}", :description => "#{attr[:description]}#{i}", :integer_field => 1)
    end
  end
  
  def properties_mappings
    {
      :id => Integer,
      :title => String,
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
  end
end

