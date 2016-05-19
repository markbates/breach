# breach

breach provides completely-optional method type checking, including support for interfaces, in Ruby, using concise and expressive syntax, allowing you to bring design-by-contract principles to Ruby.

## breach is currently under early development and as such, everything in this doc is aspirational, until it isn't.

## Usage

You can use breach for simple input type-checking:

```ruby
def print_a_string_three_times(str)
  puts str * 3
end
type_check :print_a_string_three_times, String

print_a_string_three_times(DateTime.new) # raises Breach::InputTypeCheckFailed
```

So, breach automatically will wrap the `print_a_string_three_times` method and, prior to executing it, check the input to make sure it's a `String`. If not, you'll get a `Breach::InputTypeCheckFailed` exception raised right then and there, instead of running into a much more opaque and potentially misleading error later on.

breach really shines when you want to implement interfaces/abstract classes:

```ruby
module Writer
  extend Breach::Interface

  defines :write, inputs: [String], returns: [Numeric]
end


class MyWriter
  implements Writer

  def write(s)
    return 1
  end
end

mw = MyWriter.new
mw.write("Bingo bongo") # works
mw.write(3) # raises Breach::InputTypeCheckFailed
```

When used with interfaces, breach will also catch return type errors before they propagate out into the rest of your application, providing you a much more useful exception:

```ruby
module Writer
  extend Breach::Interface

  defines :write, inputs: [String], returns: [Numeric]
end


class MyWriter
  implements Writer

  def write(s)
    return "Flippy floppy" # note: not a Numeric
  end
end

mw = MyWriter.new
mw.write("Any string") # raises Breach::ReturnTypeCheckFailed
```

If you need to support multiple potential classes of input (or return types), use an array:

```ruby
module Writer
  extend Breach::Interface

  defines :write, inputs: [String, [Hash, nil]], returns: [Numeric]
end

class MyWriter
  implements Writer

  def write(s)
    return "Flappy foo"
  end
end
mw = MyWriter.new
mw.write("Hi there", {foo: "bar"}) # works
mw.write("Interfaces are cool!", nil) # works
mw.write("A bridge too far!", DateTime.new) # raises Breach::InputTypeCheckFailed
```

* todo: optional args
* todo: splat args


Not only will your run-time errors be more useful, it'll also catch interface implementation problems *at require time*:

```ruby
class NotActuallyAWriter
  implements Writer
  # no write method
end # raises a Breach::NotImplementedError!
```

Since breach's interface definitions are just regular mix-ins, you can compose them together:

```ruby
module Writer
  extend Breach::Interface

  defines :write, inputs: [String, [Hash, nil], :optional], returns: [Numberable]
end

module Reader
  extend Breach::Interface

  defines :read, inputs: [File], returns: [String]
end

module ReadWriter
  extend Breach::Interface
  include Writer
  include Reader
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'breach'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install breach

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome [on GitHub](http://github.com/markbates/breach). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
