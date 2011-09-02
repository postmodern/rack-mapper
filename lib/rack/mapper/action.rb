module Rack
  class Mapper
    class Action

      def initialize(method_name,params)
        @method_name = method_name
        @params = params
      end

      def call(resource,params)
        resource.send(@method_name,*arguments(params))
      end

      def arguments(params)
        if @params.kind_of?(Hash)
          options = {}

          @params.each do |param_name,option_name|
            options[option_name] = params[param_name]
          end

          return options
        elsif @params.kind_of?(Array)
          @params.map { |name| params[name] }
        end
      end

    end
  end
end
