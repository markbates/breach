require "breach/version"

module Breach
  module Interface

    def defines(name, options = {})
      DefinitionManager.add(self, Definition.new(name, options))
    end

  end
end
