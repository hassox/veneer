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
  end # Test
end # Veneer
