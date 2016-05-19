module Breach
  class Definition
    attr_accessor :name, :inputs, :returns, :input_arity, :return_arity

    def initialize(name, options = {})
      self.name = name
      self.inputs = options[:inputs] || []
      self.returns = options[:returns] || []
      build_arity
    end

    def validate_implementation(m)
      self.input_arity.include?(m.arity)
    end

    def to_s
      s = "#{self.name}("
      if self.inputs.length > 0
        s << to_s_array(self.inputs, ", ")
      end
      s << ")"
      if self.returns.length > 0
        s << " #=> #{to_s_array(self.returns, ", ")}"
      end
      return s
    end

    private
    def build_arity
      l = self.inputs.length
      self.input_arity = (( self.inputs - [ :optional ] ).length..l)
      l = self.returns.length
      self.return_arity = (( self.returns - [ :optional ] ).length..l)
    end

    def to_s_array(a, sep)
      x = []
      a.each do |y|
        if y == nil
          x << "nil"
        elsif y.is_a?(Array)
          x << to_s_array(y, "|")
        else
          x << y
        end
      end
      return x.join(sep)
    end

  end
end
