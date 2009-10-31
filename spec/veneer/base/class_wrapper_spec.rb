require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")

describe Veneer::Base::ClassWrapper do
  before do
    clear_constants!
    class ::Foo
      module VeneerInterface
        class ClassWrapper
        end
        class InstanceWrapper
        end
      end
    end
  end

  
  

  
end
