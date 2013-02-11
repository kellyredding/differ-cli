# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "differ-cli/version"

Gem::Specification.new do |s|
  s.name        = "differ-cli"
  s.version     = DifferCLI::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Kelly Redding"]
  s.email       = ["kelly@kellyredding.com"]
  s.homepage    = "http://github.com/kellyredding/differ-cli"
  s.summary     = %q{command line tool for Differ}
  s.description = %q{command line tool for Differ}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency("differ")
end
