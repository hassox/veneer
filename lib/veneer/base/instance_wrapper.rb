module Veneer
  module Base
    # required methods
    #
    # save
    # save! # failure should raise ::Veneer::Errors::NotSaved
    # update
    # destroy
    # new_record?

    class InstanceWrapper
      attr_accessor :instance, :options
      def initialize(instance, opts = {})
        @instance, @options = instance, opts
      end

      def class
        @instance.class
      end

      # Checks equality of the instances
      # @api public
      def ==(other)
        case other
        when Veneer::Base::InstanceWrapper
          instance == other.instance
        else
          instance == other
        end
      end

      # Updates the attributes by trying to use the keys of the
      # attributes hash as a setter method (:"#{key}=") to the value of the hash
      # then the object is saved
      # Adapter implementors may want to overwrite may want to overwrite
      # @api public
      def update(attributes = {})
        attributes.each do |attr,value|
          instance.send(:"#{attr}=",value)
        end
        save
      end

      def update!(attributes = {})
        raise Veneer::Errors::NotSaved unless update(attributes)
      end

      # send all methods to the instance
      def method_missing(*args, &blk)
        instance.send(*args, &blk)
      end
    end
  end
end
