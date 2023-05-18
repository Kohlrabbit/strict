# Strict

Warning: This Gem has nothing to do with kylekthompson `strict` gem. Mind to also check this project as it completes the same goal as `strict-objects` (this gem).

Strict-objets is a Ruby gem compatible with Ruby 3.0+ that attempts to improve code quality by regulating developer and interpreter behavior.

## Motivation

Ruby is a great language but you never really know what value will be returned when a method is called: true ? false? nile? []? An exception ? Strict makes it possible to counterbalance this behavior by standardizing the behavior of the classes and by adding a validator above the standard classes.
## How ?

Strict offers different classes around standard Ruby classes: `String`, `Integer` and `Hash` become `Strict::String`, `Strict::Integer` and `Strict::Hash`.

These classes integrate an object definition system (prerequisite) and sequential validators.

## Examples

### String

You can create a `Strict::String` object directly by the #new constructor.

```ruby
my_string = Strict::String. new("my string")
    .expects(length: { is: 9 })
.expects(contains: "string")

my_string.valid? # true
```

This Gem also monkey-patchs the standard `String` class to convert the object to `Strict::String`:

```ruby
my_string = "my string".as_strict
my_string.class # Strict::String
```

### Hash

```ruby
my_hash = Strict::Hash.new(default: :value)
    .expects(has_keys: [:default])
    .valid? # true

my_hash.append({second: :value}, types: [String, Integer]) # raises an exception
my_hash.append({second: :value}, type: Symbol) # true
my_hash.to_hash # {default: :value, second: :value}
```

As with the `String` class, the `Hash` class is monkey-patched:

```ruby
my_hash = {"my": "value"}.as_strict
my_hash.class # Strict::Hash
```