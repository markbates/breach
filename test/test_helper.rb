$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'breach'

require 'minitest/autorun'

class Minitest::Spec

  before do
    Breach::DefinitionManager.instance.definitions.clear
    Breach::ImplementationManager.instance.implementations.clear
  end

end
