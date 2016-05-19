module Breach
  class DefinitionManager
    include Singleton

    attr_accessor :definitions

    def initialize
      @definitions = {}
    end

    def add(klass, *definitions)
      get(klass).concat(definitions)
    end

    def get(klass)
      @definitions[klass] ||= []
    end

    class << self

      def add(klass, *definitions)
        instance.add(klass, *definitions)
      end

      def get(klass)
        instance.get(klass)
      end

    end

  end
end
