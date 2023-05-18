# frozen_string_literal: true

require "test_helper"

class TestStrictHashs < Minitest::Test
  def test_length_returns_boolean
    my_hash = Strict::Hash.new(hello: :world)
    assert my_hash.length(is: 1)
    assert my_hash.length(not: 3)
    assert my_hash.length(min: 0)
    assert my_hash.length(max: 2)
    assert my_hash.length(min: 0, max: 2)
  end

  def test_expectations_are_set
    my_hash = Strict::Hash.new(hello: :world)
      .expects(length: { is: 1 })
      .expects(has_keys: [:hello])
    
    assert my_hash.expectations.include?(:length)
    assert my_hash.expectations.include?(:has_keys)
  end

  def test_has_keys_returns_bool
    my_hash = Strict::Hash.new(hello: :world, my: true)
      .expects(has_keys: [:hello, :my])
    
    assert my_hash.valid?

    my_hash = Strict::Hash.new(hello: :world)
      .expects(has_keys: [:nope])
    
    assert my_hash.has_keys([:hello, :nope]) == false
  end

  def test_append_with_type
    my_hash = Strict::Hash.new()
    assert my_hash.append({first: :value}, type: Symbol)

    assert_raises WrongTypeInHashValueError do
      my_hash.append({first: :error}, type: String)
    end

    my_hash = Strict::Hash.new()
    assert my_hash.append({first: :value, second: "value"}, types: [String, Symbol])

    assert_raises WrongTypeInHashValueError do
      my_hash.append({third: 3}, types: [String, Symbol])
      puts my_hash.to_hash
    end
  end

  def test_append_without_type
    my_hash = Strict::Hash.new()
    assert my_hash.append(first: :value)
    assert my_hash.to_hash.key?(:first)
    assert my_hash.to_hash.key?(:second) == false
  end

  def test_as_strict_conversion
    my_hash = {"hello": "world"}.as_strict
    assert my_hash.class == Strict::Hash
  end
end
