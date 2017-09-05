# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'web_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "web_parser"
  spec.version       = WebParser::VERSION
  spec.authors       = ["Daniel Mrozek"]
  spec.email         = ["mrazicz@gmail.com"]
  spec.description   = %q{Simple gem for easy web page parsing.}
  spec.summary       = %q{Simple gem for easy web page parsing. Just set xpaths, provide HTML, and get hash with informations.}
  spec.homepage      = "https://github.com/mrazicz/web_parser"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'nokogiri', '>= 1.6.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
end
