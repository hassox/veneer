require File.expand_path(File.join(File.dirname(__FILE__), '..', "..", "test_helper"))

begin
  require 'active_record'
rescue LoadError
  require 'activerecord'
end

require 'veneer/adapters/activerecord'


Veneer::Test::ActiveRecordConnection.establish

class CreateActiveRecordBar < ActiveRecord::Migration
  def self.up
    execute <<-SQL
      CREATE TABLE "active_record_bars" (
        "id" INTEGER NOT NULL, 
        "name" varchar(255), 
        "string_field" varchar(255),
        "integer_field" integer, 
        "text_field" text, 
        "float_field" float, 
        "decimal_field" decimal, 
        "datetime_field" datetime, 
        "timestamp_field" datetime, 
        "time_field" time, 
        "date_field" date, 
        "binary_field" blob, 
        "boolean_field" boolean,
        PRIMARY KEY ("id", "name")
      )
    SQL


    # For MySQL
    # create_table :active_record_bars, :force => true do |t|
    #   t.string    :name
    #   t.string    :string_field
    #   t.integer   :integer_field
    #   t.text      :text_field
    #   t.float     :float_field
    #   t.decimal   :decimal_field
    #   t.datetime  :datetime_field
    #   t.timestamp :timestamp_field
    #   t.time      :time_field
    #   t.datetime  :datetime_field
    #   t.date      :date_field
    #   t.binary    :binary_field
    #   t.boolean   :boolean_field
    # end
    # execute "alter table active_record_foos drop primary key, add primary key (id, name);"
    
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
    @primary_keys = [:id, :name]
  end
end