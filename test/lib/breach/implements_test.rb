require "test_helper"

describe "implements" do

  it "holds onto the desired implemantations" do
    class Writer
      extend Breach::Interface
      defines :write
    end
    class MyWriter
      implements Writer
    end
    is = MyWriter.instance_variable_get("@__implements__")
    is.must_include Writer
  end

end
