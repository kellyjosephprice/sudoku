# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'udokus/version'

Gem::Specification.new do |spec|
  spec.name          = "udokus"
  spec.version       = Udokus::VERSION
  spec.authors       = ["Kelly Joseph Price"]
  spec.email         = ["kellyjosephprice@gmail.com"]
  spec.summary       = %q{A sudoku generator.}
  spec.description   = %q{Generates, solves, and rates sudoku puzzles.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "descriptive_statistics"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
