require "breach/version"

module Breach
  module Interface

    def defines(name, options = {})
      DefinitionManager.add(self, Definition.new(name, options))
    end

  end
end
__END__

require 'singleton'

tracer = TracePoint.new(:end) do |tp|
  ancestors = tp.self.ancestors.dup
  ancestors.delete(tp.self)
  missing_methods = []
  ancestors.each do |ancestor|
    methods = AbstractMethodManager.instance.methods[ancestor]
    if methods
      methods.each do |m|
        unless tp.self.instance_methods.include?(m)
          missing_methods << m
        end
      end
    end
  end
  if missing_methods.any?
    raise AbstractInterface::NotImplementedError.new(*missing_methods)
  end
end

tracer.enable

class AbstractMethodManager
  include Singleton

  attr_accessor :methods

  def initialize
    @methods = {}
  end

  def add(klass, *methods)
    @methods[klass] ||= []
    @methods[klass].concat(methods)
  end

end

module AbstractInterface

  class NotImplementedError < StandardError

    def initialize(*methods)
      super "You must implement the following methods: #{methods.join(', ')}"
    end

  end

  class << self

    def included(klass)
      klass.extend(ClassMethods)
    end

  end

  module ClassMethods

    def abstract_method(*methods)
      AbstractMethodManager.instance.add(self, *methods)
    end

  end

end
