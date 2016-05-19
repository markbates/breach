require 'test_helper'

describe Breach::Interface do

  describe "defines" do

    it "must have a defines method" do
      class Foo
        extend Breach::Interface
      end

      Foo.methods.must_include :defines
    end

  end

end

