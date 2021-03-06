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

  describe "#to_s" do

    it "prints out a nice version of the definition" do
      d = Breach::Definition.new("write", inputs: [String, Hash], returns: [Numeric])
      d.to_s.must_equal("write(String, Hash) #=> Numeric")
    end

    it "ignores returns values if empty" do
      d = Breach::Definition.new("write", inputs: [String, Hash])
      d.to_s.must_equal("write(String, Hash)")
    end

    it "ignores input values if empty" do
      d = Breach::Definition.new("write")
      d.to_s.must_equal("write()")
    end

    it "handles array arguments" do
      d = Breach::Definition.new("write", inputs: [String, [Hash, nil]], returns: [Numeric, String])
      d.to_s.must_equal("write(String, Hash|nil) #=> Numeric, String")
    end

  end

end

