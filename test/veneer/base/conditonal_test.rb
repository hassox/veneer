require File.join(File.dirname(__FILE__), "..", "..", "test_helper")

class VeneerBaseConditionalTest < Test::Unit::TestCase
  context "Conditional from hash" do
    should "create a conditonal object from a blank hash" do
      c = Veneer::Conditional.from_hash({})
      assert_instance_of Veneer::Conditional, c
    end

    should "create a conditional with a limit" do
      c = Veneer::Conditional.from_hash(:limit => 5)
      assert_equal c.limit, 5
    end

    should "have an offset specified" do
      c = Veneer::Conditional.from_hash(:offset => 5)
      assert_equal c.offset, 5
    end

    context "Veneer::Conditional::Order" do
      should "let me specify a field" do
        c = Veneer::Conditional::Order.new("foo")
        assert_equal c.field, :foo
      end

      should "be decending in order by default" do
        c = Veneer::Conditional::Order.new("foo")
        assert_equal :desc, c.direction
      end

      should "let me specify an ascending order" do
        c = Veneer::Conditional::Order.new("foo", "asc")
        assert_equal :asc, c.direction
      end

      should "let me specify a decending order" do
        ["desc", :desc].each do |dir|
          c = Veneer::Conditional::Order.new("foo", dir)
          assert_equal :desc, c.direction
        end
      end
    end

    should "have an order specified as an array" do
      c = Veneer::Conditional.from_hash(:order => ["foo", "bar"])
      conditionals = [:foo, :bar].map do |f|
        Veneer::Conditional::Order.new(f)
      end
      assert_equal c.order.first, conditionals.first
      assert_equal c.order.last,  conditionals.last
    end

    should "let me specify the order with a direction" do
      c = Veneer::Conditional.from_hash(:order => ["foo asc", "bar", "baz desc"])
      conditionals = [[:foo, :asc], [:bar, :desc], [:baz, :desc]].map do |(f,d)|
        Veneer::Conditional::Order.new(f, d)
      end

      (0..2).each do |i|
        assert_equal c.order[i], conditionals[i]
      end
    end

    context "conditions" do
      context "condition object" do
        should "let me specify an equal condition" do
          c = Veneer::Conditional::Condition.new(:foo, "val", :eql)
          assert_equal :foo, c.field
          assert_equal :eql, c.operator
          assert_equal "val", c.value
        end
      end

      should "let me specify conditions" do
        c = Veneer::Conditional.from_hash(:conditions => {:foo => "bar"})
        condition = c.conditions.first
        assert_instance_of Veneer::Conditional::Condition, condition
      end

      should "let me specify conditions for different operators" do
        c = Veneer::Conditional.from_hash(:conditions => {
          "foo not"  => "bar",
          "bar not"    => 5,
          "baz gte"   => 6
        })
        foo = c.conditions.detect{|x| x.field == :foo}
        assert_not_nil          foo
        assert_equal "bar",    foo.value
        assert_equal :not,     foo.operator

        bar = c.conditions.detect{|x| x.field == :bar}
        assert_not_nil          bar
        assert_equal 5,         bar.value
        assert_equal :not,       bar.operator

        baz = c.conditions.detect{|x| x.field == :baz}
        assert_not_nil          baz
        assert_equal  6,        baz.value
        assert_equal  :gte,     baz.operator
      end

      should "not error for valid operators" do
        [:eql, :gt, :gte, :lt, :lte, :in, :not].each do |op|
          assert_nothing_raised do
            Veneer::Conditional::Condition.new(:foo, "bar", op)
          end
        end
      end

      should "error if the operator isn't valid" do
        assert_raises Veneer::Errors::ConditionalOperatorNotSupported do
          Veneer::Conditional::Condition.new(:foo, "bar", :not_real)
        end
      end
    end

  end
end
