require 'test_helper'

describe Breach::Interface do

  before do
    Breach::DefinitionManager.instance.definitions.clear
  end

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

end

