$:.push File.expand_path("../lib", __FILE__)
require "dddbl/version"

Gem::Specification.new do |s|
  s.name        = "dddbl"
  s.version     = DDDBL::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andre Gawron"]
  s.email       = ["andre@ziemek.de"]
  s.homepage    = "https://github.com/melkon/dddbl"
  s.summary     = %q{A Definition Driven Database Layer}
  s.description = %q{A Definition Driven Database Layer. First developed in php, see: http://www.dddbl.de}

  s.rubyforge_project = "dddbl"

  s.add_dependency "inifile", ">= 0.4.1"
  s.add_dependency "rdbi"

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
end
