# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rrant/version'

Gem::Specification.new do |spec|
  spec.name          = 'rrant'
  spec.version       = Rrant::VERSION
  spec.authors       = ['Tomas Koutsky']
  spec.email         = ['tomas@stepnivlk.net']

  spec.summary       = %q{simple devrant cli}
  spec.description   = %q{Have you ever wanted to read your devRant in console? Now you can!}
  spec.homepage      = 'https://github.com/stepnivlk/rrant'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables << 'rrant'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'httparty', '~> 0.14'
  spec.add_runtime_dependency 'catpix', '~> 0.2'

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'vcr', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 2.3'
end
