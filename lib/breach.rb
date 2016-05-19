require "breach/version"
require "breach/errors"
require "breach/definition"
require "breach/definition_manager"
require "breach/interface"
require "breach/implements"
require "breach/implementation_manager"
require "breach/wrap"

tracer = TracePoint.new(:end) do |tp|
  impls = Breach::ImplementationManager.get(tp.self)
  if impls
    impls.each do |impl|
      invalid = []
      defs = Breach::DefinitionManager.get(impl)
      defs.each do |d|
        begin
          m = tp.self.instance_method(d.name)
          unless d.validate_implementation(m)
            invalid << d
            next
          end
        rescue NameError
          invalid << d
          next
        end
        Breach.wrap(m, d)
      end
      if invalid.any?
        raise Breach::NotImplementedError.new(tp.self, impl, *defs)
      end
    end
  end
end

tracer.enable
