require File.expand_path(File.join(File.dirname(__FILE__), '..', "..", "test_helper"))

begin
  require 'active_record'
rescue LoadError
  require 'activerecord'
end

require 'veneer/adapters/activerecord'


# Each time you call establish_connection, ActiveRecord recreates the database
# and destroys tables for other tests
unless ActiveRecord::Base.connected?
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:") 
end

class CreateActiveRecordBar < ActiveRecord::Migration
  def self.up
    create_table :active_record_bars, :force => true do |t|
      t.string    :name
      t.string    :string_field
      t.integer   :integer_field
      t.text      :text_field
      t.float     :float_field
      t.decimal   :decimal_field
      t.datetime  :datetime_field
      t.timestamp :timestamp_field
      t.time      :time_field
      t.datetime  :datetime_field
      t.date      :date_field
      t.binary    :binary_field
      t.boolean   :boolean_field
    end
  end

  def self.down
    drop_table :active_record_foos
  end
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
  end
end