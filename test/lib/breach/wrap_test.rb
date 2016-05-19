require "test_helper"

describe "wrap" do

  it "aliases the original method" do
    class MyWriter
      def write
      end
    end
    Breach.wrap(MyWriter.instance_method(:write), Breach::Definition.new(:write))
    MyWriter.instance_methods.must_include :write_without_breach
  end

  it "calls through to the original method" do
    class MyWriter
      def write(s)
        return s.upcase
      end
    end
    Breach.wrap(MyWriter.instance_method(:write), Breach::Definition.new(:write))
    MyWriter.new.write("hello").must_equal "HELLO"
  end

  it "validates the input parameters" do
    class Writer
      extend Breach::Interface

      defines :write, inputs: [String]
    end
    class MyWriter
      implements Writer

      def write(s)
        return s.upcase
      end
    end

    ->{MyWriter.new.write(1)}.must_raise Breach::InputTypeCheckFailed
    MyWriter.new.write("hello").must_equal "HELLO"
  end

  it "validates array styled input parameters" do
    class Writer
      extend Breach::Interface

      defines :write, inputs: [String, [Hash, nil]]
    end
    class MyWriter
      implements Writer

      def write(s, opts)
        return s.upcase
      end
    end

    ->{MyWriter.new.write("hello", 1)}.must_raise Breach::InputTypeCheckFailed
    MyWriter.new.write("hello", nil).must_equal "HELLO"
    MyWriter.new.write("hello", {}).must_equal "HELLO"
  end

end
