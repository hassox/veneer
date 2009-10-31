class Test::Unit::TestCase
  def self.veneer_should_implement_find
    context "implements find" do
      should "impelement a find_all method" do
        result = Veneer(@klass).find_all
        assert_kind_of Array, result
      end
    end
  end
end
