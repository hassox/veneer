class Test::Unit::TestCase
  def self.veneer_should_implement_new_record?
    context "on an instance" do
      should "setup the test correctly" do
        assert_not_nil @klass
        assert_kind_of Class, @klass
        assert_not_nil @valid_attributes
        assert_kind_of Hash, @valid_attributes
        assert_kind_of Hash, @invalid_attributes
      end

      setup do
        @instance = Veneer(@klass).new(@valid_attributes)
      end

      context "new_record" do
        should "return true when the record is new" do
          assert @instance.new_record?
        end

        should "return false when the record is successfully saved" do
          assert @instance.save
          assert !@instance.new_record?
        end

        should "return true if the record cannot be saved" do
          v = Veneer(@klass).new(@invalid_attributes)
          assert  v.new_record?
          assert !v.save
          assert  v.new_record?
        end
      end
    end
  end
end
