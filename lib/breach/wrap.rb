module Breach

  def self.wrap(meth, definition)
    klass = meth.owner
    nm = :"#{meth.name}_without_breach"
    klass.send(:alias_method, nm, meth.name)
    klass.send(:define_method, meth.name) do |*args|
      definition.inputs.each_with_index do |input, i|
        arg = args[i]
        if input.is_a?(Array)
          # handle various types here
          # handle nil's:
          if arg == nil && input.include?(nil)
            next
          end
          # check that the argument is one of the approved classes:
          unless input.include?(arg.class)
            raise Breach::InputTypeCheckFailed.new
          end
          # TODO: check that the argument is an interface
        else
          unless arg.is_a?(input)
            raise Breach::InputTypeCheckFailed.new
          end
        end
      end
      send(nm, *args)
    end
  end

end
