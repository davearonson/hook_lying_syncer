# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hook_lying_syncer/version'

Gem::Specification.new do |spec|
  spec.name          = "hook_lying_syncer"
  spec.version       = HookLyingSyncer::VERSION
  spec.authors       = ["Dave Aronson"]
  spec.email         = ["hook_lying_syncer_gemspec.2.TRex@Codosaur.us"]
  spec.summary       = %q{Keeps method_missing and respond_to_missing? in sync.}
  spec.description   = %q{Provides a decorator class you can wrap objects in (even classes!) to keep method_missing and respond_to_missing? in sync.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"  
end
