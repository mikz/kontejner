# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kontejner/version'

Gem::Specification.new do |spec|
  spec.name          = 'kontejner'
  spec.version       = Kontejner::VERSION
  spec.authors       = ['Michal Cichra']
  spec.email         = %w[michal@o2h.cz]
  spec.summary       = %q{DNS server for Docker}
  spec.description   = %q{DNS server for Docker running on Ruby}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w[lib]

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0.0'

  spec.add_dependency 'rubydns', '~> 0.8.4'
  spec.add_dependency 'thor', '~> 0.19.1'
  spec.add_dependency 'docker-api', '~> 1.13'
  spec.add_dependency 'activesupport', '~> 4.1.4'
end
