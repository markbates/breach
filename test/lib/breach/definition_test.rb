require 'test_helper'

describe Breach::Definition do

  describe ".initialize" do

    it "sets up the definition" do
      d = Breach::Definition.new("write", inputs: [String, Hash], returns: [Numeric])
      d.inputs.must_equal [String, Hash]
      d.returns.must_equal [Numeric]
      d.input_arity.must_equal 2
      d.return_arity.must_equal 1
    end

  end

end

