require 'rack/mapper/action'

module Rack
  class Mapper
    class Resource

      # Default methods for RESTful actions
      ACTION_METHODS = {
        :index => :all,
        :show => :get,
        :create => :create,
        :update => :update,
        :destroy => :destroy
      }

      # Default options to enable
      DEFAULT_OPTIONS = {:index => true, :show => true}

      # The model of the Resource
      attr_reader :model

      # The class actions of the Resource
      attr_reader :collection_actions

      # The instance actions of the Resource
      attr_reader :resource_actions

      def initialize(model,options={},&block)
        options = DEFAULT_OPTIONS.merge(options)

        @model = model
        @collection_actions = {}
        @resource_actions = {}

        action_method = lambda { |name|
          case options[name]
          when true
            ACTION_METHODS[name]
          when String, Symbol
            name.to_sym
          end
        }

        if (index = action_method[:index])
          @collection_actions[:index] = Action.new(index)
        end

        if (show = action_method[:show])
          @collection_actions[:show] = Action.new(show,@model.key.map(&:name))
        end

        if (create = action_method[:create])
          @collection_actions[:create] = Action.new(create)
        end

        if (update = action_method[:update])
          @resource_actions[:update] = Action.new(update)
        end

        if (destroy = action_method[:destroy])
          @resource_actions[:destroy] = Action.new(destroy)
        end

        instance_eval(&block) if block
      end

      protected

      def get(name,options={});  action(:GET,name,options);  end
      def post(name,options={}); action(:POST,name,options); end

      private

      def action(verb,name,options={})
        name        = name.to_s
        method_name = options.fetch(:method,name).to_sym

        route = [verb, name]
        action = Action.new(method_name,options[:params])

        if options.fetch(:collection,true)
          @collection_actions[route] = action
        end

        if options.fetch(:resource,true)
          @resource_actions[route] = action
        end
      end

    end
  end
end
