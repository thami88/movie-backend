require "active_support/core_ext/hash/except"
require "active_support/core_ext/class/attribute"

module FactoryBot
  class DefinitionProxy
    UNPROXIED_METHODS = %w[
      __send__
      __id__
      nil?
      send
      object_id
      extend
      instance_eval
      initialize
      block_given?
      raise
      caller
      method
    ].freeze

    (instance_methods + private_instance_methods).each do |method|
      undef_method(method) unless UNPROXIED_METHODS.include?(method.to_s)
    end

    delegate :before, :after, :callback, to: :@definition

    attr_reader :child_factories

    def initialize(definition, ignore = false)
      @definition = definition
      @ignore = ignore
      @child_factories = []
    end

    def singleton_method_added(name)
      message = "Defining methods in blocks (trait or factory) is not supported (#{name})"
      raise FactoryBot::MethodDefinitionError, message
    end

    def add_attribute(name, &block)
      declaration = Declaration::Dynamic.new(name, @ignore, block)
      @definition.declare_attribute(declaration)
    end

    def transient(&block)
      proxy = DefinitionProxy.new(@definition, true)
      proxy.instance_eval(&block)
    end

    def method_missing(name, *args, &block) # rubocop:disable Style/MissingRespondToMissing
      association_options = args.first

      if association_options.nil?
        __declare_attribute__(name, block)
      elsif __valid_association_options?(association_options)
        association(name, association_options)
      else
        raise NoMethodError.new(<<~MSG)
          undefined method '#{name}' in '#{@definition.name}' factory
          Did you mean? '#{name} { #{association_options.inspect} }'
        MSG
      end
    end

    def sequence(name, *args, &block)
      sequence = Sequence.new(name, *args, &block)
      FactoryBot::Internal.register_inline_sequence(sequence)
      add_attribute(name) { increment_sequence(sequence) }
    end

    def association(name, *options)
      if block_given?
        raise AssociationDefinitionError.new(
          "Unexpected block passed to '#{name}' association " \
          "in '#{@definition.name}' factory"
        )
      else
        declaration = Declaration::Association.new(name, *options)
        @definition.declare_attribute(declaration)
      end
    end

    def to_create(&block)
      @definition.to_create(&block)
    end

    def skip_create
      @definition.skip_create
    end

    def factory(name, options = {}, &block)
      @child_factories << [name, options, block]
    end

    def trait(name, &block)
      @definition.define_trait(Trait.new(name, &block))
    end

    def traits_for_enum(attribute_name, values = nil)
      @definition.register_enum(Enum.new(attribute_name, values))
    end

    def initialize_with(&block)
      @definition.define_constructor(&block)
    end

    private

    def __declare_attribute__(name, block)
      if block.nil?
        declaration = Declaration::Implicit.new(name, @definition, @ignore)
        @definition.declare_attribute(declaration)
      else
        add_attribute(name, &block)
      end
    end

    def __valid_association_options?(options)
      options.respond_to?(:has_key?) && options.has_key?(:factory)
    end
  end
end