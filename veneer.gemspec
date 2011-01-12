# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "veneer/version"

Gem::Specification.new do |s|
  s.name        = "veneer"
  s.version     = Veneer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Daniel Neighman"]
  s.email       = ["has.sox@gmail.com"]
  s.homepage    = ""
  s.description = %q{Veneer provides basic querying, saving, deleteing and creating interface for data stores.}
  s.summary     = %q{Basic query interface for persistant data stores}

  s.rubyforge_project = "veneer"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency "hashie"
end
