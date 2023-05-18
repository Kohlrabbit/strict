# frozen_string_literal: true

require "test_helper"

class TestStrictStrings < Minitest::Test
  def test_expects_are_set
    my_string = Strict::String.new("my string")
      .expects(length: { is: 9 })
      .expects(contains: "my")

    assert my_string.valid?
    assert my_string.to_s == "my string"
  end

  def test_length_method_returns_boolean
    my_string = Strict::String.new("my string")
    assert my_string.length(is: 9) == true
    assert my_string.length(min: 3) == true
    assert my_string.length(max: 10) == true
    assert my_string.length(min: 1, max: 5) == false
  end

  def test_contains_method_returns_boolean
    my_string = Strict::String.new("my string")
    assert my_string.contains("my")
  end

  def test_valid_raises_an_exception
    my_string = Strict::String.new("a")
      .expects(contains: "b")
    
    assert_raises InvalidStringError do
      my_string.valid?
    end
  end

  def test_as_strict_conversion
    my_string = "hello".as_strict
    assert my_string.class == Strict::String
  end
end
