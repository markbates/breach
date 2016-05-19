class Object

  def self.implements(*interfaces)
    Breach::ImplementationManager.add(self, *interfaces)
  end

end
