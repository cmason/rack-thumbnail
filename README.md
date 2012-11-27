rack-thumbnail
==============

Rack middleware for creating image thumbnails on-the-fly.

A light-weight alternative to CarrierWave and other thumbnail generators

Install
=======

    gem 'thumbnail', :git => 'git://github.com/christianhellsten/thumbnail.git'
    gem 'rack-thumbnail', :git => 'git://github.com/christianhellsten/rack-thumbnail.git'

Sinatra:

    use Rack::Thumbnail::Middleware, :uri => '/images'

Rails (application.rb):

    config.middleware.use "Rack::Thumbnail::Middleware", :uri => '/images'

Usage
=====

Allow pre-defined named thumbnails to be created via URLs, e.g. /images/cat-large.png:

    Rack::Thumbnail.register :large, width: 940, height: 150, gravity: :north
    Rack::Thumbnail.register :small, width: 620, height: 100, gravity: :north

Allow 900x100 and 600x50 thumbnails to be created via URLs, e.g. /images/cat-900x100.png:

    Rack::Thumbnail.register '900x100'
    Rack::Thumbnail.register '600x50'

Allow thumbnails of any size to be created via URLs, e.g. /images/cat-10x10.png:

    Rack::Thumbnail.allow_any_size = true
