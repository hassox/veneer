class Test::Unit::TestCase
  def self.veneer_should_implement_create_with_valid_attributes
    context "implements create with valid attributes" do
      should "setup the spec correctly" do
        assert_not_nil @klass
        assert_kind_of Class, @klass
        assert_not_nil @valid_attributes
        assert_kind_of Hash, @valid_attributes
      end

      should "create the object from the hash" do
        r = Veneer(@klass).create(@valid_attributes)
        assert_instance_of @klass::VeneerInterface::InstanceWrapper, r
      end

      should "create the object from the hash with create!" do
        r = Veneer(@klass).create!(@valid_attributes)
        assert_instance_of @klass::VeneerInterface::InstanceWrapper, r
      end

      should "create a new instance of the object" do
        r = Veneer(@klass).create_instance(@valid_attributes)
        assert_instance_of @klass::VeneerInterface::InstanceWrapper, r
      end
    end
  end
end
