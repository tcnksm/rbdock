# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rbdock/version'

Gem::Specification.new do |spec|
  spec.name          = "rbdock"
  spec.version       = Rbdock::VERSION
  spec.authors       = ["tcnksm"]
  spec.email         = ["nsd22843@gmail.com"]
  spec.summary       = %q{Generate Dockerfile for ruby/rails/sinatra.}
  spec.description   = %q{Generate Dockerfile for ruby or running rails/sinatra.}
  spec.homepage      = "https://github.com/tcnksm/rbdock"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "erubis", "~> 2.7.0"
  spec.add_dependency "log4r", "~> 1.1.10"
  spec.add_dependency "gem-man"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 2.13"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "yard", "~> 0.8"
  spec.add_development_dependency "redcarpet", "~> 2.2"
  spec.add_development_dependency "ronn"
end
