class Test::Unit::TestCase
  def self.veneer_should_impelement_destroy_all
    context "implements destroy_all" do
      should "setup the test correctly" do
        assert_not_nil @klass
        assert_kind_of Class, @klass
        assert_not_nil @valid_attributes
        assert_kind_of Hash, @valid_attributes
      end

      context "destroy_all" do
        setup do
          Veneer(@klass).destroy_all
          assert_equal 0, Veneer(@klass).all.size
          (0..5).each do |i|
            Veneer(@klass).new(:name => "foo#{i}", :order_field1 => i).save
          end
        end

        should "setup the spec correctly" do
          assert_equal 6, Veneer(@klass).all.size
        end

        should "destroy all records" do
          Veneer(@klass).destroy_all
          assert_equal 0, Veneer(@klass).all.size
        end
      end
    end
  end
end
