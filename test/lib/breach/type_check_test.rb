require "test_helper"

describe "type_check" do

  it "calls through to the original method" do
    class MyWriter
      def write(s)
        return s.upcase
      end
      type_check :write
    end
    MyWriter.new.write("hello").must_equal "HELLO"
  end

  it "validates the input parameters" do
    class MyWriter
      def write(s)
        return s.upcase
      end
      type_check :write, inputs: [String]
    end

    ->{MyWriter.new.write(1)}.must_raise Breach::InputTypeCheckFailed
    MyWriter.new.write("hello").must_equal "HELLO"
  end

  it "validates array styled input parameters" do
    class MyWriter
      def write(s, opts)
        return s.upcase
      end
      type_check :write, inputs: [String, [Hash, nil]]
    end

    ->{MyWriter.new.write("hello", 1)}.must_raise Breach::InputTypeCheckFailed
    MyWriter.new.write("hello", nil).must_equal "HELLO"
    MyWriter.new.write("hello", {}).must_equal "HELLO"
  end

  it "validates return parameters" do
    class GoodWriter
      def write(s)
        return s.upcase
      end
      type_check :write, inputs: [String], returns: [String]
    end
    GoodWriter.new.write("hello").must_equal "HELLO"

    class BadWriter
      def write(s)
        return 1
      end
      type_check :write, inputs: [String], returns: [String]
    end
    ->{BadWriter.new.write("hello")}.must_raise Breach::ReturnTypeCheckFailed
  end

  it "validates multiple return values" do
    class GoodWriter
      def write(s)
        return s.upcase, s.length
      end
      type_check :write, inputs: [String], returns: [String, Numeric]
    end
    s, i = GoodWriter.new.write("hello")
    s.must_equal "HELLO"
    i.must_equal 5

    class BadWriter
      def write(s)
        return s, true
      end
      type_check :write, inputs: [String], returns: [String, Numeric]
    end

    ->{BadWriter.new.write("hello")}.must_raise Breach::ReturnTypeCheckFailed
  end
end
