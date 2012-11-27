# https://github.com/christianhellsten/thumbnail
require 'thumbnail'
require 'rack-thumbnail/version'
require 'rack-thumbnail/middleware'
require 'rack-thumbnail/image'

#
# Rack middleware for creating image thumbnails on-the-fly.
#
# First register the middleware:
#
#   # Sinatra
#   use Rack::Thumbnail::Middleware, :uri => '/images'
#
#   # Rails (application.rb)
#   config.middleware.use "Rack::Thumbnail::Middleware", :uri => '/images'
#
# Then configure your thumbnails by calling Rack::Thumbnail.register or Rack::Thumbnail.allow_any_size.
#
# Use case 1:
#
# Allow any image under /images to be resized to any size, e.g. /images/me-1280x1024.png:
#
#   Rack::Thumbnail.allow_any_size = true
#
# Use case 2: Allow thumbnails of size 50x50 or 150x150, e.g. /images/me-150x150.png:
#   Rack::Thumbnail.register '150x150'
#   Rack::Thumbnail.register '50x50'
#
# Use case 3: Allow named thumbnails of size 620x100 and include extra parameters (gravity & method).
#
#   Rack::Thumbnail.register :large, width: 620, height: 100, gravity: :north, method: :cut_to_fit
#
#
module Rack
  module Thumbnail
    class << self
      attr_accessor :allow_any_size
      def register(name, options={})
        Middleware.register(name, options)
      end
    end
  end
end
