module Rack
  module Thumbnail
    class Middleware
      def initialize(app, options = {})
        @app = app
        @options = options
        @uri = options.fetch(:uri)
      end

      class << self
        attr_reader :thumbnails
        @@thumbnails = {}

        # Register a thumbnail by size
        def size(dimensions, options={})
          width, height = dimensions.split('x')
          raise "Invalid dimensions #{dimensions.inspect}. Should be <width>x<height>!" unless width && height
          options.merge!(:width => width, :height => height)
          named(dimensions, options)
        end

        # Register a named thumbnail
        def named(name, options)
          @@thumbnails[name.to_sym] = options
        end

        # Register a thumbnail by name or size
        def register(name, options)
          unless name.to_s.include?('x')
            named(name, options)
          else
            size(name, options)
          end
        end

        # Returns options for a named thumbnail
        def options_for(name)
          options = @@thumbnails[name.to_sym]
          options.dup if options
        end

        def environment
          @@environment ||= (ENV['RACK_ENV']||ENV['RAILS_ENV']||'development').to_sym
        end
      end

      def call(env)
        Image.new(env, @options).process
        status, headers, response = @app.call(env)
        [status, headers, response]
      end
    end
  end
end
