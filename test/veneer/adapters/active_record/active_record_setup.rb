require 'activerecord'
require 'veneer/adapters/activerecord'
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

class CreateActiveRecordFoo < ActiveRecord::Migration

  def self.up
    create_table :active_record_foos, :force => true do |t|
      t.string  :name
      t.integer :order_field1
    end
  end

  def self.down
    drop_table :active_record_foos
  end
end

CreateActiveRecordFoo.up

class ActiveRecordFoo < ActiveRecord::Base
  attr_accessor :password, :password_confirmation
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
