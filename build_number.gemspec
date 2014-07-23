# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'build_number/version'

Gem::Specification.new do |spec|
  spec.name          = 'build_number'
  spec.version       = BuildNumber::VERSION
  spec.authors       = ['Rob Scaduto']
  spec.email         = ['rscaduto@thirdwave.it']
  spec.summary       = %q{Store and increment build numbers}
  spec.description   = %q{Library for storing and incrementing a build number in your local project directory.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
end
