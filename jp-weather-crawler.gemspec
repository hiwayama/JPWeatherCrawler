# -*- encoding: utf-8 -*-
require File.expand_path('../lib/jp-weather-crawler/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["ymis1080"]
  gem.description   = %q{Crawler from Japan Meteorological Agency}
  gem.summary       = %q{Crawler from Japan Meteorological Agency}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "jp-weather-crawler"
  gem.require_paths = ["lib"]
  gem.version       = JPWeather::Crawler::VERSION
end
