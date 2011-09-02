module Rack
  class Mapper

    def initialize(app,options={},&block)
      @app = app

      @routes = {}
      @actions = {}

      instance_eval(&block) if block
    end

    protected

    # Regular expression to match actions
    ACTION_REGEXP = /^[a-z][a-zA-Z0-9_]$/

    def expose(model,options={})
      name = options.fetch(:name,default_resource_name(model))
      url = options.fetch(:map,name)

      # remove leading and trailing /
      url = url[1..-1] if url[0,1] == '/'
      url = url[0..-2] if url[-1..-1] == '/'

      @routes[url.split('/')] = model

      @actions[model] = {
        :index   => options.fetch(:index,:all),
        :create  => options.fetch(:create,:create),
        :show    => options.fetch(:show,:get),
        :destroy => options.fetch(:destroy,:destroy),

        :class => {},
        :instance => {}
      }

      model.relationships.each do |relationship|
        @resources[mode][relationship.name] = relationship.child_model
      end
    end

    Inflector = DataMapper::Inflector

    def default_resource_name(model)
      Inflector.pluralize(
        Inflector.underscore(
          Inflector.demoularize(model.name)
        )
      )
    end

  end
end
