require 'virtus'

module Rack
  class Mapper
    class Params

      include Virtus

      def self.params
        @params ||= {}
      end

      def self.param(name,mapping=nil,type=nil)
        # map the param name to the attribute name
        params[(mapping || name).to_s] = name.to_sym

        attribute(name,(type || ::Object))
      end

      def initialize(params)
        super()

        self.class.params.each do |param_name,attribute_name|
          self[attribute_name] = params[param_name]
        end
      end

      def to_a
        attributes = []

        self.class.attributes.each do |attribute|
          name = attribute.name
          attributes << attribute_get(name) if respond_to?(name)
        end

        attributes
      end

      def to_ary
        to_a
      end

      def inspect
        "#<#{self.class}: #{attributes.inspect}>"
      end

    end
  end
end
