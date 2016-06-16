$:.push File.expand_path('../lib', __FILE__)
require 'whiskers/version'

Gem::Specification.new do |s|
  s.add_runtime_dependency 'sass', '~> 3.4'
  s.add_runtime_dependency 'bourbon', '~> 4.2'
  s.add_runtime_dependency 'neat', '~> 1.7'
  s.add_runtime_dependency 'bitters', '~> 1.2'
  s.add_runtime_dependency 'thor', '~> 0.19'
  s.name          = 'whiskers'
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.version       = Whiskers::VERSION
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files         = `git ls-files`.split("\n")
  s.date          = '2016-06-09'
  s.description   = <<-DESC
    Whiskers is a library for generating website templates with a few basic styles. 
    Whiskers provides a basic directory structure for handling coffeescript and SASS.
    Whiskers relies on Bourbon, Neat, & Refills from thoughtbot. 
  DESC
  s.summary       = 'A quick and tidy way to start a site with SASS/Coffeescript'
  s.authors       = ['Zane Swafford']
  s.email         = 'zane@otters.io'
  s.homepage      = 'http://rubygems.org/gems/whiskers'
  s.license       = 'BSD'
end