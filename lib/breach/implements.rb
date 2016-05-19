class Object

  def self.implements(interface)
    ( @__implements__ ||= [] ).push(interface)
  end

end
