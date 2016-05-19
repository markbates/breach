class Object

  def self.type_check(sym, options = {})
    d = Breach::Definition.new(sym, options)
    m = self.instance_method(sym)
    Breach.wrap(m, d)
  end

end
