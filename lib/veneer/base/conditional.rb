module Veneer
  class Conditional

    def self.from_hash(hash)
      new(hash)
    end

    attr_reader :options
    def initialize(opts)
      @options = Hashie::Mash.new(opts || {})
      odr = [@options.delete("order")].flatten.compact
      @ordering = odr.nil? || odr.empty? ? [] : begin
        odr.map do |order|
          field, direction = order.split(" ")
          Order.new(field, (direction || :desc))
        end
      end

      conds = opts.fetch(:conditions, {})
      @conditions = conds.map do |k,v|
        field, operator = k.to_s.split(" ")
        args = [field, v]
        args << operator.to_sym if operator
        Veneer::Conditional::Condition.new(*args)
      end
    end

    def limit
      @options[:limit]
    end

    def offset
      @options[:offset]
    end

    def order
      @ordering
    end

    def conditions
      @conditions
    end

    class Order
      attr_reader :field, :direction
      def initialize(field, direction = :desc)
        @field = field.to_sym
        @direction = direction.to_sym
      end

      def ascending?
        direction == :asc
      end

      def decending?
        !ascending?
      end

      def ==(other)
        self.class ==  other.class &&
        field == other.field &&
        direction == other.direction
      end
    end

    class Condition
      attr_accessor :field, :operator, :value

      VALID_OPERATORS = [:eql, :gt, :gte, :lt, :lte, :in, :not]

      def initialize(field, value, operator = :eql)
        @field, @value, @operator = field.to_sym, value, operator.to_sym
        raise Veneer::Errors::ConditionalOperatorNotSupported, "#{operator.inspect} not a valid operator" unless VALID_OPERATORS.include?(operator)
      end
    end
  end
end
