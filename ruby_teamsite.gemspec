# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ruby_teamsite/version"

Gem::Specification.new do |s|
  s.name        = "ruby_teamsite"
  s.version     = RubyTeamSite::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Bryan A. Crossland"]
  s.email       = ["bacrossland@gmail.com"]
  s.homepage    = "https://github.com/bacrossland/ruby_teamsite"
  s.summary     = %q{Ruby Gem for accessing and using Autonomy Interwoven TeamSite}
  s.description = %q{This Ruby Gem gives Ruby access to Autonomy Interwoven TeamSite actions normally found in TeamSite Perl Modules or TeamSite CLTs.}

  s.rubyforge_project = "ruby_teamsite"
  s.license = 'MIT'

  s.files         = Dir.glob("**/**/**")
  s.require_paths = ["lib"]
  s.add_dependency('nokogiri','>= 1.4.4')

end
