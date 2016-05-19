module Breach
  class Definition
    attr_accessor :name, :inputs, :returns, :input_arity, :output_arity

    def initialize(name, options = {})
      self.name = name
      self.inputs = options[:inputs] || []
      self.returns = options[:returns] || []

      self.input_arity = self.inputs.length
      self.output_arity = self.returns.length
    end

  end
end
