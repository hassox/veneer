class Test::Unit::TestCase
  def self.veneer_should_implement_save
    context "on an instance" do
      should "setup the test correctly" do
        assert_not_nil @klass
        assert_kind_of Class, @klass
        assert_not_nil @valid_attributes
        assert_kind_of Hash, @valid_attributes
        assert_kind_of Hash, @invalid_attributes
      end

      setup do
        @invalid  = Veneer(@klass).new(@invalid_attributes)
        @valid    = Veneer(@klass).new(@valid_attributes)
      end

      context "save" do
        should "return true when it can save" do
          assert_true @valid.save
        end

        should "return false when it can't save" do
          assert_false @invalid.save
        end
      end
    end
  end

  def self.veneer_should_implement_save!
    context "save!" do
      should "setup the test correctly" do
        assert_not_nil @klass
        assert_kind_of Class, @klass
        assert_not_nil @valid_attributes
        assert_kind_of Hash, @valid_attributes
        assert_kind_of Hash, @invalid_attributes
      end

      setup do
        @invalid  = Veneer(@klass).new(@invalid_attributes)
        @valid    = Veneer(@klass).new(@valid_attributes)
      end

      should "return true when successful" do
        assert_true @valid.save!
      end

      should "raise Veneer::Errors::NotSaved when fails to save!" do
        assert_raises Veneer::Errors::NotSaved do
          @invalid.save!
        end
      end
    end
  end
end
