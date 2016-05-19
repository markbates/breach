require "test_helper"

describe "implements" do

  it "holds onto the desired implemantations" do
    class Writer
      extend Breach::Interface
      defines :write
    end
    class MyWriter
      implements Writer
      def write
      end
    end
    is = Breach::ImplementationManager.get(MyWriter)
    is.must_include Writer
  end

end
