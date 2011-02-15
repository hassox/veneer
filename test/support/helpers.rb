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
          case database_name
          when :mysql
            ::ActiveRecord::Base.establish_connection(:adapter => "mysql2", :database => "veneer_test")
          else # use sqlite
            # Each time you call establish_connection, ActiveRecord recreates the database
            # and destroys tables for other tests
            unless ::ActiveRecord::Base.connected?
              ::ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:") 
            end
          end
        end
        
        def migration
          case database_name
          when :sqlite then ActiveRecordHelper::Migrations::SQLite
          when :mysql  then ActiveRecordHelper::Migrations::MySQL
          end
        end
        
        protected 
        
        def database_name
          case ENV['AR_DATABASE']
          when "mysql" then :mysql
          else :sqlite
          end
        end
      end # class << self
      
      module Migrations
        module SQLite
          def up
            # Need raw SQL here. ActiveRecord doesn't allow to specify composite primary 
            # keys in migration and SQLite does not allow to specify them once table is created.
            
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
          end

          def down
            drop_table :active_record_bars
          end
        end # Sqlite
        
        module MySQL
          def up
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
            # Need to specify composite primary key.
            execute "alter table active_record_bars drop primary key, add primary key (id, name);"
          end
          
          def down
            drop_table :active_record_bars
          end
        end # MySQL
      end # Migrations
    end # ActiveRecordHelper
  end # Test
end # Veneer
