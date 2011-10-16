$:.unshift File.expand_path('../lib', __FILE__)

require 'downrightnow'
require 'downrightnow/version'

Gem::Specification.new do |gem|
  gem.name        = "downrightnow"
  gem.version     = DownRightNow.version
  gem.platform    = Gem::Platform::RUBY
  gem.authors     = "Barry Allard (steakknife)"
  gem.email       = "barry@barryallard.name"
  gem.homepage    = "https://github.com/steakknife/downrightnow"
  gem.summary     = "Unofficial Ruby interface and command-line to DownRightnow.com"
  gem.description = "See http://downrightnow.com"


  # Man files are required because they are ignored by git
  gem.files            = Dir['lib/**/*.rb', 'bin/*']
  gem.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n").select { |d| d =~ %r{^(README|bin/|data/|ext/|lib/|spec/|test/)} }
  gem.executables      = "downrightnow"
  gem.require_paths    = ['lib']

  gem.add_dependency 'nokogiri', '>= 1.4.0'
  gem.add_dependency 'trollop', '>= 1.16'
end
