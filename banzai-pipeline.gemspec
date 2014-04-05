# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'banzai-pipeline/version'

Gem::Specification.new do |spec|
  spec.name          = "banzai-pipeline"
  spec.version       = BanzaiPipeline::VERSION
  spec.authors       = ["Carlos Rodriguez", "Abby Ihrig"]
  spec.email         = ["carlos@eddorre.com", "alihrig@gmail.com"]
  spec.summary       = %q{Fastest pipeline of them all.}
  spec.description   = %q{Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "capistrano", ">= 2.0"
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
