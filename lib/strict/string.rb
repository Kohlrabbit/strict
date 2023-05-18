module Strict
  class String < Validator
    attr_reader :expectations

    def initialize(value)
      @value = value
      @expectations = {}
      @exception = InvalidStringError
    end

    # validates object expectations using
    # parent class (Validator)
    def valid?
      super
    end

    # merges submitted expectations to a object-scoped
    # expectation lists (as a Hash)
    # expectations can be chained together. Example:
    #   my_string = Strict::String.new("a")
    #     .expects(length: { is: 1 })
    #     .expects(contains: "a")
    #     .valid? # true
    #
    # @param expects [Hash] expectations to run
    # @return [Strict::String] instance of current object
    def expects(expects = {})
      @expectations = @expectations.merge(expects)
      self
    end

    # Validates the value length based on conditions.
    # Example:
    #   my_string = Strict::String.new("my string")
    #   my_string.length(is: 3) # false
    #   my_string.length(is: 9) # true
    #   my_string.length(not: 9) # false
    #   my_string.length(min: 3) # true
    #   my_string.length(min: 1, max: 5) # false
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

      if pattern.key?(:not)
        return false if value_length == pattern[:not]
      end

      # Once every condition is passed, we validate the result.
      true
    end

    # Alias for Array#include? in the object
    # Example:
    #   my_string = Strict::String.new("my string")
    #   my_string.contains("my") # true
    #   my_string.contains("nope") # false
    #
    # @param pattern [String] needle to find in the heystack.
    # @return [Boolean]
    def contains(pattern)
      @value.include?(pattern)
    end

    # Returns the initial value as a String instance.
    #
    # @return [String]
    def to_s
      @value.to_s
    end
  end
end

class String
  def as_strict
    Strict::String.new(self)
  end
end