require 'rack/mapper/action'

module Rack
  class Mapper
    class Resource

      # The model of the Resource
      attr_reader :model

      # The class actions of the Resource
      attr_reader :class_actions

      # The instance actions of the Resource
      attr_reader :instance_actions

      def initialize(model,options={},&block)
        @model = model

        @class_actions = {}
        @instance_actions = {}

        instance_eval(&block) if block
      end

      protected

      def get(name,options={});  action(name,options); end
      def post(name,options={}); action(name,options); end

      private

      def action(name,options={})
        method_name = options.fetch(:method,name)

        method_name = if RUBY_VERSION > '1.9'
                        # convert the method name to a Symbol on 1.9.x
                        method_name.to_sym
                      else
                        # convert the method name to a String on 1.8.x
                        method_name.to_s
                      end

        if @model.respond_to?(method_name)
          @class_actions[name] = Action.new(method_name,options[:params])
        end

        if @model.instance_methods.include?(method_name)
          @instance_actions[name] = Action.new(method_name,options[:params])
        end
      end

    end
  end
end
