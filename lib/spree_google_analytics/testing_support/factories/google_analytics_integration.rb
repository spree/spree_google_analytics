FactoryBot.define do
  factory :google_analytics_integration, class: Spree::Integrations::GoogleAnalytics do
    active { true }
    preferred_measurement_id { FFaker::Internet.password }
    store { Spree::Store.default }
  end
end
