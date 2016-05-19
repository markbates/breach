module Breach
  class ImplementationManager
    include Singleton

    attr_accessor :implementations

    def initialize
      @implementations = {}
    end

    def add(klass, *implementations)
      get(klass).concat(implementations)
    end

    def get(klass)
      @implementations[klass] ||= []
    end

    class << self

      def add(klass, *implementations)
        instance.add(klass, *implementations)
      end

      def get(klass)
        instance.get(klass)
      end

    end

  end
end
