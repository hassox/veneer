class Test::Unit::TestCase
  def self.veneer_should_implement_validations
    context "implements validations" do
      setup do
        Veneer(@klass).destroy_all
      end

      should "setup the test correctly" do
        assert_not_nil @klass
        assert_kind_of Class, @klass
        assert_not_nil @valid_attributes
        assert_kind_of Hash, @valid_attributes
        assert_not_nil @valid_attributes[:name]
      end

      context "validates_presence_of" do
        setup do
          key = [@klass, :validates_presence_of, :name]
          unless $validations.include?(key)
            Veneer(@klass).validates_presence_of(:name)
            $validations << key
          end
        end

        should "allow addition of a validation for presence_of" do
          attr = @valid_attributes.dup
          attr.delete(:name)
          k = Veneer(@klass).new(attr)
          assert_false k.valid?
        end
      end

      context "validates_uniqueness_of" do
        setup do
          key = [@klass, :validates_uniqueness_of, :name]
          unless $validations.include?(key)
            Veneer(@klass).validates_uniqueness_of(:name)
            $validations << key
          end
        end

        should "not allow duplicate data" do
          k = Veneer(@klass).new(@valid_attributes)
          assert_true k.save
          k2 = Veneer(@klass).new(@valid_attributes)
          assert_false k2.valid?
        end

        # TODO: Get some introspection of validations happening
        should "allow_non duplicate data" do
          k = Veneer(@klass).new(@valid_attributes)
          assert_true k.save
          k2 = Veneer(@klass).new(@valid_attributes.merge(:name => "not a duplicate"))
          assert_true k2.save
        end
      end

      context "validates_confirmation_of" do
        setup do
          key = [@klass, :validates_confirmation_of, :password]
          unless $validations.include?(key)
            Veneer(@klass).validates_confirmation_of(:password)
            $validations << key
          end
        end

        should "be invalid without confirmation" do
          k = Veneer(@klass).new(@valid_attributes)
          k.password_confirmation = "Not Confirmed"
          assert_false k.valid?
        end
      end

      context "validates_with_method" do
        setup do
          key = [@klass, :validates_with_method, :v_with_m_test]
          unless $validations.include?(key)
            Veneer(@klass).validates_with_method(:v_with_m_test)
            $validations << key
          end
        end

        should "be invalid with an invalid through v_with_m_test" do
          k = Veneer(@klass).new(@valid_attributes)
          k.name = "v_with_m_test"
          assert_false k.valid?
        end
      end
    end
  end
end
