class Test::Unit::TestCase
  def self.veneer_should_implement_destroy
    context "on an instance" do
      should "setup the test correctly" do
        assert_not_nil @klass
        assert_kind_of Class, @klass
        assert_not_nil @valid_attributes
        assert_kind_of Hash, @valid_attributes
      end

      setup do
        Veneer(@klass).destroy_all
        @valid    = Veneer(@klass).new(@valid_attributes)
      end

      should "setup the spec" do
        assert_true @valid.save
        r = Veneer(@klass).first(:conditions => {:name => @valid.instance.name})
        assert_equal @valid, r
      end

      should "destroy the object" do
        @valid.save
        v = @valid
        assert_equal v, @valid.destroy
      end

      should "remove the object from the collection" do
        @valid.save
        assert_equal @valid, Veneer(@klass).first(:conditions => {:name => @valid.name})
        @valid.destroy
        assert_nil Veneer(@klass).first(:conditions => {:name => @valid.name})
      end
    end
  end
end
