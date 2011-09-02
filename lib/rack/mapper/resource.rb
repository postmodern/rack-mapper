require 'rack/mapper/action'

module Rack
  class Mapper
    class Resource

      attr_reader :model

      attr_reader :class_actions

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

        if @model.respond_to?(method_name)
          @class_actions[name] = Action.new(method_name,options[:params])
        end
      end

    end
  end
end
