module Veneer
  module Spec
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
      end # clear_constants!
      
    end # Helpers
  end # Spec
end # Veneer
