# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'therapeutor/version'

Gem::Specification.new do |spec|
  spec.name          = "therapeutor"
  spec.version       = Therapeutor::VERSION
  spec.authors       = ["Pablo Baños López"]
  spec.email         = ["pablo@baden.eu.org"]

  spec.summary       = %q{Generator of automatised therapy-deciding questionnaires}
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/pbanos/therapeutor"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.1.0'

  spec.add_dependency "activemodel", "~> 4.2.5"
  spec.add_dependency "activesupport", "~> 4.2.1"
  spec.add_dependency "thor", '~> 0.19'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
