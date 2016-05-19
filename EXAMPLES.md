```ruby
module Writer
  extend Interface

  defines :write, inputs: [String, [Hash, nil], :optional], returns: [Numberable]
end

module Reader
  extend Interface

  defines :reader, inputs: [File], returns: [String]
end

module ReadWriter
  extend Interface
  include Writer
  include Reader
end

class Numerable < Interface
  defines :to_i, returns: [Numeric]
end

class MyWriter
  implements Writer

  def write(s)
    return 1
  end

end

def write(s)
  verify_input(s) # raise exception
  out = write_impl(s)
  verify_output(out) # raise exception
  return out
end

def write_something(w, a)
  # //do work
end
type_check :write_something, Writer
```
