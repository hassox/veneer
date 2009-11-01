module Veneer
  module Base
    class ClassWrapper < BasicObject
      attr_reader :klass, :opts
      def initialize(klass, opts)
        @klass, @opts = klass, opts
      end

      # @api public
      def create!(opts = {})
        instance = new(opts)
        instance.save!
        instance
      end

      # @api public
      def create(opts = {})
        instance = new(opts)
        instance.save
        instance
      end

      # @api implementor
      def new(opts = {})
        ::Kernel.raise Errors::NotImplemented
      end

      # @api public
      def first(opts={})
        conditional = Veneer::Conditional.new(opts)
        Veneer(find_one(conditional))
      end

      # @api public
      def all(opts={})
        conditional = Veneer::Conditional.new(opts)
        find_many(conditional).map{|element| Veneer(element)}
      end

      # Should return an array or array like structure with elements matching the provided conditional
      # @api implementor
      def find_many(conditional)
        ::Kernel.raise Errors::NotImplemented
      end

      # A single object matching the conditional
      # @api_implementor
      def find_first(conditional)
        ::Kernel.raise Errors::NotImplemented
      end
    end
  end
end
