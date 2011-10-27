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

    module ActiveRecordHelper
      class << self
        def establish_connection
          unless ::ActiveRecord::Base.connected?
            ::ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:") 
          end
        end
      end # Migrations
    end # ActiveRecordHelper
  end # Test
end # Veneer
