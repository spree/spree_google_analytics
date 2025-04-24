# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_google_analytics/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_google_analytics'
  s.version     = SpreeGoogleAnalytics::VERSION
  s.summary     = "Spree Commerce Google analytics Extension"
  s.required_ruby_version = '>= 3.0'

  s.author    = 'You'
  s.email     = 'you@example.com'
  s.homepage  = 'https://github.com/your-github-handle/spree_google_analytics'
  s.license = 'AGPL-3.0-or-later'

  s.files        = Dir["{app,config,db,lib,vendor}/**/*", "LICENSE.md", "Rakefile", "README.md"].reject { |f| f.match(/^spec/) && !f.match(/^spec\/fixtures/) }
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree', '>= 5.1.0.alpha'
  s.add_dependency 'spree_storefront', '>= 5.1.0.alpha'
  s.add_dependency 'spree_admin', '>= 5.1.0.alpha'
  s.add_dependency 'spree_extension'

  s.add_development_dependency 'spree_dev_tools'
end
