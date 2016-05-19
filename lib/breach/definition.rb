module Breach
  class Definition
    attr_accessor :name, :inputs, :returns, :input_arity, :return_arity

    def initialize(name, options = {})
      self.name = name
      self.inputs = options[:inputs] || []
      self.returns = options[:returns] || []

      self.input_arity = self.inputs.length
      self.return_arity = self.returns.length
    end

  end
end
