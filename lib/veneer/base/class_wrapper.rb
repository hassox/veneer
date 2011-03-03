module Veneer
  module Base
    # Required methods
    # new
    # find_many
    # destroy_all
    # model_classes
    #
    #
    # Optional Methods
    # find_first
    # create!
    # create
    # count
    # sum
    # max
    # min
    #
    class ClassWrapper < BasicObject
      attr_reader :klass, :opts
      def initialize(klass, opts)
        @klass, @opts = klass, opts
      end

      def self.inherited(klass)
        subclasses << klass
      end

      def self.subclasses
        @subclasses ||= []
      end

      def self.model_classes
        raise ::Veneer::Errors::NotImplemented
      end

      # Provides an array of associations of the format
      # [
      #   {
      #     :name       => :association_name,
      #     :class_name => 'TheClass'
      #   }
      # ]
      #
      # The collection associations maps has_many, has n, embeds_many and the like.
      # @api public
      def collection_associations
        []
      end

      # Provides an array of association for belongs_to type associaions
      # of the format:
      #
      # [
      #   {
      #     :name       => :assocaition_name,
      #     :class_name => 'TheClass'
      #   }
      # ]
      def member_associations
        []
      end

      # Create an instance of the object.
      # That is, instantiate and persist it in one step.
      # Raise an error if the object is not persisted
      # @api public
      # @see create
      def create!(opts = {})
        instance = new(opts)
        instance.save!
        instance
      end

      # Create an instance of the object.
      # That is, instantiate and persist it in one step.
      # @api public
      # @see create!
      def create(opts = {})
        instance = new(opts)
        instance.save
        instance
      end

      # Instantiate an item
      # The interface required is that a hash of attributes is passed
      # The object should take each key, and set the value provided
      # @api implementor
      def new(opts = {})
        klass.new(opts)
      end

      # Provides query access to the first item who meets the conditions in the passed in options hash
      #
      # @api public
      # @see Veneer::Base::ClassWrapper.all
      def first(opts={})
        ::Kernel.Veneer(find_first(Hashie::Mash.new(opts)))
      end

      # Provides an interface to query the objects
      #
      # Options that must be supported are
      #
      #   * :limit
      #   * :offset
      #   * :conditions
      #   * :order
      #
      # @api public
      def all(opts={})
        find_many(::Hashie::Mash.new(opts))
      end

      # Obtains a count of all matching records
      # Takes the same options as all
      #
      # Adapter implementers should overwrite with a more
      # efficient implementation
      # @see all
      def count(opts={})
        all(opts).size
      end

      # Obtains a sum of all matching records for the given field
      # Takes the same options as all
      #
      # Adapter implementers should overwrite with a more
      # efficient implementation
      # @see all
      def sum(field, opts={})
        opts = ::Hashie::Mash.new(opts)
        all(opts).inject(0){|sum, item| (item.send(field) || 0) + sum }
      end

      # Obtains the minimum value of the given field of all matching records
      # Takes the same options as all
      #
      # Adapter implementers should overwrite with a more
      # efficient implementation
      # @see all
      def min(field, opts={})
        opts = ::Hashie::Mash.new(opts)
        all(opts).inject(nil) do |min, item|
          val = item.send(field)
          min = val if !val.nil? && (min.nil? || val < min)
          min
        end
      end

      # Obtains the maximum value of the given field of all matching records
      # Takes the same options as all
      #
      # Adapter implementers should overwrite with a more
      # efficient implementation
      # @see all
      def max(field, opts={})
        opts = ::Hashie::Mash.new(opts)
        all(opts).inject(nil) do |max, item|
          val = item.send(field)
          max = val if !val.nil? && (max.nil? || val > max)
          max
        end
      end

      # Should return an array or array like structure with elements matching the provided conditions hash
      # @api implementor
      # @see Veneer::Base::ClassWrapper.all
      def find_many(opts)
        ::Kernel.raise Errors::NotImplemented
      end

      # Should return an array of primary keys
      # @api public
      def primary_keys
        ::Kernel.raise Errors::NotImplemented
      end

      # Should return an array of ActiveModel::Validator class instances for given property name
      # @api public
      def validators_on(name)
        ::Kernel.raise Errors::NotImplemented
      end

      def find_first(opts)
        opts[:limit] = 1
        find_many(opts).first
      end
    end
  end
end
