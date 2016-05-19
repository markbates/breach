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

    def validate_inputs(args)
      validate(self.inputs, args, Breach::InputTypeCheckFailed)
    end

    def validate_returns(args)
      validate(self.returns, [args].flatten, Breach::ReturnTypeCheckFailed)
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
    def validate(allowed, args, ex)
      allowed.each_with_index do |allow, i|
        arg = args[i]
        if allow.is_a?(Array)
          # handle various types here
          # handle nil's:
          if arg == nil && allow.include?(nil)
            next
          end
          # check that the argument is one of the approved classes:
          unless allow.include?(arg.class)
            raise ex.new
          end
          # TODO: check that the argument is an interface
        else
          unless arg.is_a?(allow)
            raise ex.new
          end
        end
      end
    end

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
