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
          arguments = []

          @params.each do |param_name|
            if (value = params[param_name])
              arguments << value
            end
          end

          arguments
        end
      end

      module Params
        def arguments(params)
          params
        end
      end

      # The method name of the action
      attr_reader :method_name

      # The params to pass to the method
      attr_reader :params

      def initialize(method_name,params=nil)
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
          raise(TypeError,"params must be a Hash, Array or nil")
        end
      end

      def dispatch(resource,params)
        resource.send(@method_name,*arguments(params))
      end

    end
  end
end
