require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Veneer::Proxy do
  before do
    clear_constants! :Foo, :Bar

    class ::Foo
      def initialize(opts = {})
        raise if opts[:invalid]
      end

      class VeneerInterface
        class ClassWrapper
          def initialize(klass)
          end

          def create!(opts = {})
            Veneer(Foo.new(opts))
          rescue
            raise Veneer::Errors::NotSaved
          end
          
          def create(opts = {})
            new(opts)
          end

          def new(opts = {})
            Veneer(Foo.new(opts))
          rescue
            Veneer(Foo.new)
          end
          
        end

        class InstanceWrapper
          def initialize(instance)
          end
        end
      end
    end
  end
  
  it "should be a BasicObject" do
    Veneer::Proxy.ancestors.should include(BasicObject)
  end

  describe "Foo Veneer constants" do
    before do
      @klass = Foo
      @valid_attributes = {:name => "foo"}
      @invalid_attributes = {:invalid => true} 
      @instance = Foo.new
    end

    it_should_behave_like "it has the required Veneer constants"
    it_should_behave_like "it implements create with valid attributes"
    it_should_behave_like "it implements create with invalid attributes"
  end

  
  
end
