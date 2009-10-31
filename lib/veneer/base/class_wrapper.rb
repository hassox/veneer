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
        raise NotImplemented
      end

      # @api public
      def first(opts={})
      end

      # @api public
      def all(opts={})
      end

      # @api implementor
      def find_many
        raise NotImplemented
      end

      # @api_implementor
      def find_one
        raise NotImplemented
      end

    end
  end
end
