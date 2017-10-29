# Axi
A small object streaming library for Crystal

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  axi:
    github: handicraftsman/axi
```

## Usage

```crystal
require "axi"
```

To create a stream, call `Axi::Stream(I,O)` where I - input type and O - output type:

```crystal
stream = Axi::Stream(Int32, Int64).new
```

Setting the transform block:

```crystal
stream.transform ->(val : Int32) { val.to_i64 }
```

If the input type is same as the output type and the transform block is not set,
`send` and `transform` methods return input value.
Else these methods return `nil`.

Sending a value:

```crystal
stream.send(2) # => 2 : Int64
```

As an additional feature, Axi supports executing blocks each time a value is transformed.
These blocks must return `nil` though.

```crystal
stream.on_transform ->(ival : Int32, oval: Int64) { "do something"; nil }
```

Axi supports linking streams to objects which implement `send(val : O)` method so
each transformed value is sent to all linked objects. This means that you can relay
values to other streams and channels from the standard library.

```crystal
stream.link(other_object)
```

## Contributing

1. Fork it ( https://github.com/handicraftsman/axi/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [handicraftsman](https://github.com/handicraftsman) Nickolay Ilyushin - creator, maintainer
