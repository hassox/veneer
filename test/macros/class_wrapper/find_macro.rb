class Test::Unit::TestCase
  def self.veneer_should_implement_find
    context "implements find" do
      setup do
        Veneer(@klass).destroy_all
        (0..5).each do |i|
          Veneer(@klass).new(:order_field1 => i).save!
        end
      end

      teardown{ Veneer(@klass).destroy_all }

      should "impelement a find_all method" do
        result = Veneer(@klass).find_many(Veneer::Conditional.from_hash({}))
        assert_kind_of Array, result
      end

      should "implement a find_first method" do
        result = Veneer(@klass).find_first(Veneer::Conditional.from_hash({}))
      end

      should "implement limit" do
        total = Veneer(@klass).find_many(Veneer::Conditional.from_hash({}))
        assert_not_equal 3, total.size
        result = Veneer(@klass).find_many(Veneer::Conditional.from_hash(:limit => 3))
        assert_equal 3, result.size
      end

      should "implement order" do
        result = Veneer(@klass).find_many(Veneer::Conditional.from_hash(:order => "order_field1"))
        raw = result.map{|i| i.order_field1 }.compact
        sorted = raw.sort.reverse
        assert_equal raw, sorted
      end

      should "implement order decending" do
        result = Veneer(@klass).find_many(Veneer::Conditional.from_hash(:order => "order_field1 desc"))
        raw = result.map{|i| i.order_field1 }.compact
        sorted = raw.sort.reverse
        assert_equal raw, sorted
      end

      should "implement order ascending" do
        result = Veneer(@klass).find_many(Veneer::Conditional.from_hash(:order => "order_field1 asc"))
        raw = result.map{|i| i.order_field1}.compact
        sorted = raw.sort
        assert_equal raw, sorted
      end

      should "impelment offset" do
        total = Veneer(@klass).find_many(Veneer::Conditional.from_hash({}))
        result = Veneer(@klass).find_many(Veneer::Conditional.from_hash({:offset => 2, :limit => 2}))

        assert_equal((total[2..3]), result)
      end

      context "conditions" do
        setup do
          Veneer(@klass).new(:name => "bar").save
          Veneer(@klass).new(:name => "foo").save
          Veneer(@klass).new(:name => "foobar").save
        end

        should "implement basic conditions" do
          total = Veneer(@klass).find_many(Veneer::Conditional.from_hash({}))
          result = Veneer(@klass).find_many(Veneer::Conditional.from_hash(:conditions => {:name => "foo"}))
          assert_equal 1, result.size
        end

        should "implement :not conditions" do
          Veneer(@klass).all(:conditions => {:name => nil}).map(&:destroy)
          total = Veneer(@klass).find_many(Veneer::Conditional.from_hash({}))
          result = Veneer(@klass).find_many(Veneer::Conditional.from_hash(:conditions => {"name not" => "bar"}))
          assert_equal((total.size - 1), result.size)
        end

        should "implement gt conditions" do
          total = Veneer(@klass).find_many(Veneer::Conditional.from_hash({}))
          expected = total.select{|i| !i.order_field1.nil? && i.order_field1 > 3}
          result = Veneer(@klass).find_many(Veneer::Conditional.from_hash(:conditions => {"order_field1 gt" => 3}))
          assert_equal expected.size, result.size
        end

        should "implement gte conditions" do
          total = Veneer(@klass).find_many(Veneer::Conditional.from_hash({}))
          expected = total.select{|i| !i.order_field1.nil? && i.order_field1 >= 3}
          result = Veneer(@klass).find_many(Veneer::Conditional.from_hash(:conditions => {"order_field1 gte" => 3}))
          assert_equal 3, result.size
        end

        should "implement :lt condition" do
          result = Veneer(@klass).find_many(Veneer::Conditional.from_hash(:conditions => {"order_field1 lt" => 3}))
          assert_equal 3, result.size
        end

        should "implement a lte condition" do
          total     = Veneer(@klass).find_many(Veneer::Conditional.from_hash({}))
          expected  = total.select{|i| !i.order_field1.nil? && i.order_field1 <= 3}
          result = Veneer(@klass).find_many(Veneer::Conditional.from_hash(:conditions => {"order_field1 lte" => 3}))
          assert_equal expected.size, result.size
        end

        should "implement an :in condition" do
          total = Veneer(@klass).find_many(Veneer::Conditional.from_hash({}))
          expected = total.select{|i| ["foo", "bar"].include?(i.name)}
          result = Veneer(@klass).find_many(Veneer::Conditional.from_hash(:conditions => {"name in" => ["foo", "bar"]}))
          assert_equal expected.size, result.size
        end
      end
    end
  end
end
