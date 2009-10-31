class Test::Unit::TestCase
  def self.veneer_should_have_the_required_veneer_constants
    context "required constants" do

      should "have correctly setup the spec" do
        assert_kind_of Class, @klass
      end

      should "have a VeneerInterface constant" do
        assert_nothing_raised do
          @klass::VeneerInterface
        end
      end

      should "have a VeneerInterface::ClassWrapper" do
        assert_nothing_raised do
          @klass::VeneerInterface::ClassWrapper
        end
      end

      should "inherit the class wrapper from the base class wrapper" do
        assert_contains @klass::VeneerInterface::ClassWrapper.ancestors, ::Veneer::Base::ClassWrapper
      end
    end
  end
end
