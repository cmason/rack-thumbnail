module Rack
  module Thumbnail
    class Image
      def initialize(env, options)
        @uri = options.fetch(:uri)
        @uri_regex = /(-\w+\.)(.+)?$/
        @public_dir = options.fetch(:public_dir, 'public')
        @path = env["PATH_INFO"]
        @destination = destination
        # <width>x<height> or <name>
        @match = $1[1..-2] if @path.match(@uri_regex)
      end
      
      # Returns path to thumbnail, e.g. public/images/thumbnail.png
      def destination
        res = @path
        ext = ::File.extname(res)
        # remove extension
        if ext
          res = res[0...(res.size-ext.size)]
        end
        # Always use PNG
        res += '.png'
        ::File.join(@public_dir, res)
      end

      def process
        create if path_matches?
      end

      def create
        # If no handler is registered then register thumbnails on the fly, i.e. allow any thumbnail size
        Middleware.size(@match) if thumbnail_options.nil? && Rack::Thumbnail.allow_any_size
        debug
        ::Thumbnail.create(thumbnail_options) if create?
      end

      def thumbnail_options
        @thumbnail_options ||= if @match
          options = Middleware.options_for(@match)
          if options
            options[:in] = source_file
            options[:out] = @destination
          end
          options
        end
      end

      def source_file
        @source_file ||= ::File.join(@public_dir, @path.gsub(@uri_regex, '') + ::File.extname(@path))
      end

      def allowed?
        !!thumbnail_options
      end

      def destination_exists?
        ::File.file?(@destination)
      end

      def source_exists?
        ::File.file?(source_file)
      end

      def path_matches?
        !!@path.match(@uri)
      end

      def debug
        if Middleware.environment == :development
          puts "################"
          puts create? ? 'Creating thumbnail' : "Won't create thumbnail!!"
          puts " ->source " + (source_exists? ? "exists #{source_file}" : "doesn't exist!!")
          puts " ->destination " + (destination_exists? ? "exists #{@destination}!!" : "doesn't exist")
          puts " ->path: #{@path}"
          puts " ->match: #{@match}"
          puts " ->options: #{thumbnail_options.inspect}"
          puts " ->handlers: #{Middleware.thumbnails}"
        end
      end

      def create?
        allowed? && !destination_exists? && source_exists?
      end
    end
  end
end
