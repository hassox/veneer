require File.expand_path(File.join(File.dirname(__FILE__), '..', "..", "test_helper"))

begin
  require 'active_record'
rescue LoadError
  require 'activerecord'
end

require 'veneer/adapters/activerecord'


Veneer::Test::ActiveRecordHelper.establish_connection

class CreateActiveRecordBar < ActiveRecord::Migration
  def self.up
    create_table :active_record_bars, :force => true do |t|
      t.string    :name
      t.string    :string_field
      t.integer   :integer_field
      t.text      :text_field
      t.float     :float_field
      t.decimal   :decimal_field, :precision => 5, :scale => 2
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
    drop_table :active_record_bars
  end
end

CreateActiveRecordBar.up

class ActiveRecordBar < ActiveRecord::Base
  validates_presence_of :integer_field
end

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
    @primary_keys = [:id]
    @properties_with_length = {
      :string_field => 255,
      :text_field => nil

    }
    @properties_with_validations = {
      :integer_field => [ActiveModel::Validations::PresenceValidator]
    }
  end
end
