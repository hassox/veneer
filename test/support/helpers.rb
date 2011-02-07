module Veneer
  module Test
    module Helpers

      def clear_constants!(*args)
        Object.class_eval do
          args.each do |obj|
            begin
              remove_const(obj)
            rescue
            end
          end
        end
      end
    end # Helpers
    
    module ActiveRecordConnection
      def self.establish
        # Each time you call establish_connection, ActiveRecord recreates the database
        # and destroys tables for other tests
        unless ActiveRecord::Base.connected?
          ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:") 
        end
      end
    end # ActiveRecordConnection
  end # Test
end # Veneer
