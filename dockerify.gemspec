# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dockerify/version'

Gem::Specification.new do |spec|
  spec.name          = "dockerify"
  spec.version       = Dockerify::VERSION
  spec.authors       = ["Christopher Butcher"]
  spec.email         = ["cbutcher@gmail.com"]
  spec.summary       = %q{A Ruby gem to generate Docker and Docker Compose configuration files to utilize Phusion's Passenger Docker containers}
  spec.description   = %q{This gem is intended to help you generate Docker and Docker Compose configuration files, to simply host web apps using Phusion's Passenger Docker containers}
  spec.homepage      = "https://github.com/chrisbutcher/dockerify"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor', "~> 0.19"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'minitest', "~> 5"
  spec.add_development_dependency 'mocha', "1.1"
end
