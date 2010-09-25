# -*- encoding: utf-8 -*-
require File.expand_path("../lib/rubyspell/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "rubyspell"
  s.version     = Rubyspell::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Tim Gourley']
  s.email       = ['tgourley@gmail.com']
  s.homepage    = "http://github.com/bratta/rubyspell"
  s.summary     = "Pure-ruby spell checker and suggestion engine"
  s.description = "Check spelling and get suggestions, based on http://norvig.com/spell-correct.html"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "rubyspell"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rspec"
  
  s.add_dependency "optiflag"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
