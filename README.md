rack-thumbnail
==============

Rack middleware for creating image thumbnails on-the-fly.

A light-weight alternative to CarrierWave and other thumbnail generators

Usage
=====

Use case 1: Allow any image under /images to be resized to any size

    # e.g. /images/me-1280x1024.png
    use Rack::Thumbnail, :uri => '/images'

Use case 2: Allow any image under /images to be resized to 50x50 or 150x150

    # e.g. /images/me-150x150.png
    use Rack::Thumbnail, :uri => '/images', :dimensions => ['50x50', '150x150']

Use case 3: Allow any image under /images to be resized to 50x50 or 150x150. Allow padding or cutting of thumbnails to fit given dimensions.

    # e.g. /images/me-50x50-cut.png
    use Rack::Thumbnail, :uri => '/images', :dimensions => ['50x50', '150x150'], :methods => { :pad => :pad_to_fit, :crop => :cut_to_fit }
