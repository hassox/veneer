module Veneer
  module Base
    class ClassWrapper < BasicObject
      attr_reader :klass, :opts
      def initialize(klass, opts)
        @klass, @opts = klass, opts
      end

      def create!(opts = {})
        instance = create_instance(opts)
        instance.save!
        instance
      end

      def create(opts = {})
        instance = create_instance(opts)
        instance.save
        instance
      end

      def create_instance(opts = {})
        raise NotImplemented
      end
    end
  end
end
