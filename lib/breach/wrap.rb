module Breach

  def self.wrap(meth, definition)
    klass = meth.owner
    nm = :"#{meth.name}_without_breach"
    klass.send(:alias_method, nm, meth.name)
    klass.send(:define_method, meth.name) do |*args|
      definition.validate_inputs(args)
      returns = send(nm, *args)
      definition.validate_returns(returns)
      return returns
    end
  end

end
