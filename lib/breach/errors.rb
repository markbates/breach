module Breach

  class NotImplementedError < StandardError
    def initialize(klass, interface, *definitions)
      super("#{klass} does not implement #{interface} correctly! Missing the following definitions:\n#{definitions.join("\n")}")
    end
  end

  class TypeCheckedFailed < StandardError

  end

  class InputTypeCheckFailed < TypeCheckedFailed

  end

end
