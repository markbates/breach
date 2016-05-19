require 'test_helper'

describe Breach::Interface do

  describe "defines" do

    it "must have a defines method" do
      class Foo
        extend Breach::Interface
      end

      Foo.methods.must_include :defines
    end

    it "creates a Definition and adds it to the manager" do
      class Writer
        extend Breach::Interface

        defines :write, inputs: [String], outputs: [Numeric]
      end

      defitions = Breach::DefinitionManager.get(Writer)
      defitions.length.must_equal 1
    end

  end

  it "raises an exception if the interface isn't implemented" do
    class Writer
      extend Breach::Interface

      defines :write
    end
    ->{
      class MyWriter
        implements Writer
      end
    }.must_raise(Breach::NotImplementedError)
  end

  it "doesn't raise an exception if the interface is fullfilled" do
    class Writer
      extend Breach::Interface

      defines :write, inputs: [String], outputs: [Numeric]
    end
    class MyWriter
      implements Writer

      def write(s)
        return 1
      end
    end
  end

end

