module Veneer
  module Test
    module BeforeSaveSetup
      def check_before_save
        $captures << :check_before_save
        if name == "raise_on_before_save"
          raise Veneer::Errors::BeforeSaveError, [:name, "cannot be raise_on_before_save"]
        else
          true
        end
      end
    end
  end
end
