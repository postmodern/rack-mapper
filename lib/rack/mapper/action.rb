module Rack
  class Mapper
    class Action

      module Options
        def arguments(params)
          options = {}

          @params.each do |param_name,option_name|
            options[option_name] = params[param_name]
          end

          options
        end
      end

      module Arguments
        def arguments(params)
          @params.map { |param_name| params[param_name] }
        end
      end

      module Params
        def arguments(params)
          params
        end
      end

      def initialize(method_name,params)
        @method_name = method_name
        @params = params

        case @params
        when Hash
          extend Options
        when Array
          extend Arguments
        when nil
          extend Params
        else
          raise(":params must be a Hash, Array or nil")
        end
      end

      def dispatch(resource,params)
        resource.send(@method_name,*arguments(params))
      end

    end
  end
end
