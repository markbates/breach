module Breach
  class Definition
    attr_accessor :name, :inputs, :returns, :input_arity, :return_arity

    def initialize(name, options = {})
      self.name = name
      self.inputs = options[:inputs] || []
      self.returns = options[:returns] || []
      build_arity
    end

    private
    def build_arity
      l = self.inputs.length
      self.input_arity = (( self.inputs - [ :optional ] ).length...l)
      l = self.returns.length
      self.return_arity = (( self.returns - [ :optional ] ).length...l)
    end

  end
end
