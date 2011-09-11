require 'rack/mapper/params'

require 'dm-core/support/mash'

module Rack
  class Mapper
    class Action

      module Options
        protected

        def initialize_params(params)
          params.each do |name,(mapping,type)|
            # map `true` to the option name
            mapping = name if mapping == true

            @params.param(name,mapping,type)
          end
        end

        def arguments(params)
          [@params.new(params).to_hash]
        end
      end

      module Arguments
        protected

        def initialize_params(params)
          params.each do |name,type|
            @params.param(name,type)
          end
        end

        def arguments(params)
          @params.new(params).to_a
        end
      end

      module Mash
        def initialize_params(params)
          @params = nil
        end

        def arguments(params)
          [DataMapper::Mash.new(params)]
        end
      end

      # The method name of the action
      attr_reader :method_name

      # The params to pass to the method
      attr_reader :params

      def initialize(method_name,params=nil)
        @method_name = method_name
        @params = Class.new(Params)

        case params
        when Hash
          extend Options
        when Array
          extend Arguments
        when nil
          extend Mash
        else
          raise(TypeError,"params must be a Hash, Array or nil")
        end

        initialize_params(params)
      end

      def dispatch(resource,params)
        resource.send(@method_name,*arguments(params))
      end

    end
  end
end
