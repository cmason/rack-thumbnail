# https://github.com/christianhellsten/thumbnail
require 'thumbnail'
#
# Rack middleware for creating image thumbnails on-the-fly.
#
# Use case 1: Allow any image under /images to be resized to any size
#
#   # e.g. /images/me-1280x1024.png
#   use Rack::Thumbnail, :uri => '/images'
#
# Use case 2: Allow any image under /images to be resized to 50x50 or 150x150
#
#   # e.g. /images/me-150x150.png
#   use Rack::Thumbnail, :uri => '/images', :dimensions => ['50x50', '150x150']
#
# Use case 3: Allow any image under /images to be resized to 50x50 or 150x150. Allow padding or cutting of thumbnails to fit given dimensions.
#
#   # e.g. /images/me-50x50-cut.png
#   use Rack::Thumbnail, :uri => '/images', :dimensions => ['50x50', '150x150'], :methods => { :pad => :pad_to_fit, :crop => :cut_to_fit }
#
class Rack::Thumbnail
  def initialize(app, options = {})
    @app = app
    @uri = options[:uri]
    @public_dir = options.fetch(:public_dir, 'public')
    @uri_regex = options.fetch(:uri_regex, /-(\d+)x(\d+)-?(\w+)?/) # Extracts width, height, method
    @allowed_methods = options.fetch(:methods, {})
    @allowed_dimensions = options[:dimensions]
  end

  def allowed_dimension?(width, height)
    @allowed_dimensions.any? ? @allowed_dimensions.include?([width, 'x', height].join) : true
  end

  def call(env)
    path = env["PATH_INFO"]
    destination = File.join('public', path)
    if path.match(@uri) && !File.exist?(destination)
      _, width, height, method = path.match(@uri_regex).to_a
      if allowed_dimension?(width, height)
        source = File.join(@public_dir, path.gsub(@uri_regex, ''))
        Thumbnail.create(
          :in => source,
          :out => destination,
          :method => @allowed_methods.fetch((method||'').to_sym, :cut_to_fit),
          :width => width.to_i,
          :height => height.to_i
        )
      end
    end
    status, headers, response = @app.call(env)
    [status, headers, response]
  end
end
