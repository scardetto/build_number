# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'semver'

Gem::Specification.new do |spec|
  spec.name          = 'build_number'
  spec.version       = SemVer.find.format '%M.%m.%p'
  spec.authors       = ['Rob Scaduto']
  spec.email         = ['rscaduto@thirdwave.it']
  spec.summary       = %q{Store and increment build numbers}
  spec.description   = %q{Library for storing and incrementing a build number in your local project directory.}
  spec.homepage      = 'http://github.com/scardetto/build_number'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'semver2'
end
