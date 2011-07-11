# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "subtitlesource/version"

Gem::Specification.new do |s|
  s.name        = "subtitlesource"
  s.version     = Subtitlesource::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Linus Oleander"]
  s.email       = ["linus@oleander.nu"]
  s.homepage    = "https://github.com/oleander/subtitlesource"
  s.summary     = %q{Ruby bindings for subtitlesource.org}
  s.description = %q{Ruby bindings for subtitlesource.org.}

  s.rubyforge_project = "subtitlesource"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
