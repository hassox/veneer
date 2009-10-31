module Veneer
  module Base
    class InstanceWrapper
      attr_accessor :instance, :options
      def initialize(instance, opts = {})
        @instance, @options = instance, opts
      end
    end
  end
end
