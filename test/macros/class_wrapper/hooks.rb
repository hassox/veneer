class Test::Unit::TestCase
  def self.veneer_should_implement_before_save_hooks
    context "impelements before_save" do
      should "setup the test correctly" do
        assert_not_nil @klass
        assert_kind_of Class, @klass
        assert_not_nil @valid_attributes
        assert_kind_of Hash, @valid_attributes
      end

      context "before_save" do
        setup do
          $captures = []
          Veneer(@klass).before_save :check_before_save
          @klass.class_eval do
            include Veneer::Test::BeforeSaveSetup
          end unless Veneer::Test::BeforeSaveSetup > @klass
        end

        teardown{ $captures = [] }

        should "run the before save block" do
          Veneer(@klass).new(@valid_attributes).save
          assert_contains $captures, :check_before_save
        end

        should "allow me to raise inside the before save without propergating the issue further" do
          assert_nothing_raised do
            Veneer(@klass).new(@valid_attributes.merge(:name => "raise_on_before_save")).save
          end
        end

        should "allow me to save! with an invalid before_save hook and do the right thing" do
          assert_raise(::Veneer::Errors::NotSaved) do
            Veneer(@klass).new(@valid_attributes.merge(:name => "raise_on_before_save")).save!
          end
        end
      end
    end
  end
end
