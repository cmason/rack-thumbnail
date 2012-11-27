# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack-thumbnail/version'

Gem::Specification.new do |gem|
  gem.name          = "rack-thumbnail"
  gem.version       = Rack::Thumbnail::VERSION
  gem.authors       = ["Christian Hellsten"]
  gem.email         = ["christian@aktagon.com"]
  gem.description   = %q{A light-weight alternative to CarrierWave and other thumbnail generators}
  gem.summary       = %q{A light-weight alternative to CarrierWave and other thumbnail generators}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
