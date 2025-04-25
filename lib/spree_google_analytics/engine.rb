module SpreeGoogleAnalytics
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_google_analytics'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'spree_google_analytics.environment', before: :load_config_initializers do |_app|
      SpreeGoogleAnalytics::Config = SpreeGoogleAnalytics::Configuration.new
    end

    initializer 'spree_google_analytics.assets' do |app|
      app.config.assets.precompile += %w[spree_google_analytics_manifest]
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
