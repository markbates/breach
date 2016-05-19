require "breach/version"
require "breach/errors"
require "breach/definition"
require "breach/manager"
require "breach/interface"
require "breach/implements"

module Breach
end

tracer = TracePoint.new(:end) do |tp|
  impls = tp.self.instance_variable_get("@__implements__")
  if impls
    impls.each do |impl|
      invalid = []
      defs = Breach::DefinitionManager.get(impl)
      defs.each do |d|
        begin
          m = tp.self.instance_method(d.name)
          unless d.validate_implementation(m)
            invalid << d
          end
        rescue NameError
          invalid << d
        end
      end
      if invalid.any?
        raise Breach::NotImplementedError.new(tp.self, impl, *defs)
      end
    end
  end
  # ancestors = tp.self.ancestors.dup
  # ancestors.delete(tp.self)
  # ancestors.each do |ancestor|
  #   puts %{=== ancestor -> #{ancestor.inspect}}
  #   impls = ancestor.instance_variable_get("@__implements__")
  #   if impls
  #     impls.each do |impl|
  #       puts %{=== impl -> #{impl.inspect}}
  #       invalid = []
  #       defs = Breach::DefinitionManager.get(impl)
  #       defs.each do |d|
  #         m = ancestor.method[d.name]
  #         unless d.validate_implementation(m)
  #           invalid << defs
  #         end
  #       end
  #       puts %{=== invalid -> #{invalid.inspect}}
  #       if invalid.any?
  #         raise Breach::NotImplementedError.new(ancestor, impl, *defs)
  #       end
  #     end
  #   end
  # end
end

tracer.enable
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
