require 'test_helper'

describe Breach::Definition do

  describe ".initialize" do

    it "sets up the definition" do
      d = Breach::Definition.new("write", inputs: [String, Hash], returns: [Numeric])
      d.inputs.must_equal [String, Hash]
      d.returns.must_equal [Numeric]
      d.input_arity.must_equal(2..2)
      d.return_arity.must_equal(1..1)
    end

    it "handles optional arity" do
      d = Breach::Definition.new("write", inputs: [String, :optional])
      d.input_arity.must_equal(1..2)
    end

  end

  describe "#validate_implementation" do

    it "returns true if the function validates the implementation" do
      d = Breach::Definition.new("write", inputs: [String, Hash], returns: [Numeric])

      def write(s, h)
      end

      m = method(:write)
      d.validate_implementation(m).must_equal true
    end

  end

end

