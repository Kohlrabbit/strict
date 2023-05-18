module Strict
  class Hash < Validator
    attr_reader :expectations
  
    def initialize(value = {})
      @value = value
      @expectations = {}
      @exception = InvalidHashError
    end

    # validates object expectations using
    # parent class (Validator)
    # Example:
    #   my_hash = Strict::Hash.new(first: :value)
    #     .expects(length: { is: 1 })
    #     .valid? # true
    #
    #   my_hash = Strict::Hash.new(first: :value)
    #     .expects(length: { is: 2 })
    #     .valid? # raises an exception
    # @return [Boolean]
    def valid?
      super
    end

    # Adds new expectations from a hash
    # Can be chained.
    # Example:
    #   my_hash = Strict::Hash.new(hello: :world)
    #     .expects(length: { is: 1 })
    #     .expects(has_keys: [:hello])
    #   my_hash.expectations # {length ..., has_keys...}
    #
    # @return [Strict::Hash] instance of the current object.
    def expects(expects)
      @expectations = @expectations.merge(expects)
      self
    end

    # Ensures all required keys are present in the value
    # One missing key in the value will return false for the whole.
    # Example:
    #   my_hash = Strict::Hash.new(hello: :world, my: :value)
    #   my_hash.has_keys([:hello]) # true
    #   my_hash.has_keys([:hello, :my]) # true
    #   my_hash.has_keys([:nope]) # false
    #   my_hash.has_keys([:nope, :my]) # false
    # 
    # @param pattern [Array] array of required keys
    # @return [Boolean] result of method
    def has_keys(pattern)
      pattern.each do |key|
        unless @value.key?(key)
          return false
        end
      end

      true
    end

    # Validates the value length based on conditions.
    # Example:
    #   my_hash = Strict::Hash.new(my: "hash")
    #   my_hash.length(is: 1) # true
    #   my_hash.length(not: 2) # true
    #   my_hash.length(max: 2) # true
    #   my_hash.length(min: 0) # true
    #
    # @param pattern [Hash] conditions as a Hash
    # @return [Boolean] result of method
    def length(pattern)
      value_length = @value.length

      if pattern.key?(:is)
        return false if value_length != pattern[:is]
      end

      if pattern.key?(:min)
        return false if value_length < pattern[:min]
      end

      if pattern.key?(:max)
        return false if value_length > pattern[:max]
      end

      # Once every condition is passed, we validate the result.
      true
    end

    # Returns the raw value as a standard hash
    #
    # @return [Hash] initialized default value.
    def to_hash
      @value
    end

    # Appends hash elements to object value.
    # Supports parameters (type, types) to sanitize entries.
    # Returns true if `hash` has been inserted in the object hash.
    # Example:
    #   my_hash = Strict::Hash.new()
    #   my_hash.append({first: :value}, type: Symbol) # true
    #   my_hash.append({second: "value"}, types: [Integer, String]) # true
    #   my_hash.append({third: 3}, types: [String, Symbol]) # error
    #
    # @param hash [Hash] hash to merge to the current object Hash
    # @param params [Hash] parameters to sanitize entries (:type = Class, :types = [Class])
    # @return [Boolean]
    def append(hash = {}, params = {})
      if params.key?(:type)
        return _append_with_type(hash, params[:type])
      end

      if params.key?(:types)
        return _append_with_types(hash, params[:types])
      end

      @value = @value.merge(hash)
    end

    # Called by #append if params contains a `type` key.
    # Raises an exception if hash values aren't of required `type`.
    # 
    # @param hash [Hash] hash to merge to object hash.
    # @param type [Class] class to compare values with.
    def _append_with_type(hash = {}, type)
      hash.each do |key, value|
        unless value.instance_of?(type)
          raise WrongTypeInHashValueError, [hash, type]
        end

        @value = @value.merge(key => value)
      end
    
      true
    end

    # Called by #append if params contains a `types` key.
    # Raises an exception if hash values aren't of required `types`.
    # 
    # @param hash [Hash] hash to merge to object hash.
    # @param types [Array(Class)] classes to compare values with.
    def _append_with_types(hash, types)
      hash.each do |key, value|
        unless types.include?(value.class)
          raise WrongTypeInHashValueError, [hash, types]
        end

        @value = @value.merge(key => value)
      end

      true
    end
  end
end

class Hash
  def as_strict
    Strict::Hash.new(self)
  end
end