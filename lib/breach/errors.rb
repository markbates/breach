module Breach

  class NotImplementedError < StandardError
    def initialize(klass, interface, *definitions)
      super("#{klass} does not implement #{interface} correctly! Missing the following definitions:\n#{definitions.join("\n")}")
    end
  end

end
