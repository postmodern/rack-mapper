module Rack
  class Mapper

    attr_reader :routes

    attr_reader :resources

    def initialize(app,options={},&block)
      @app = app

      @routes = {}
      @resources = {}

      instance_eval(&block) if block
    end

    def call(env)
    end

    protected

    # Regular expression to match actions
    ACTION_REGEXP = /^[a-z][a-zA-Z0-9_]$/

    def map(model,options={},&block)
      name = options.fetch(:name,default_resource_name(model))
      url = options.fetch(:map,name)

      # remove leading and trailing /
      url = url[1..-1] if url[0,1] == '/'
      url = url[0..-2] if url[-1..-1] == '/'

      @routes[url.split('/')] = model
      @resources[model] = Resource.new(model,options,&block)
    end

    Inflector = DataMapper::Inflector

    def default_resource_name(model)
      Inflector.pluralize(
        Inflector.underscore(
          Inflector.demodulize(model.name)
        )
      )
    end

  end
end
