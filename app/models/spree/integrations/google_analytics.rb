module Spree
  module Integrations
    class GoogleAnalytics < Spree::Integration
      preference :measurement_id, :string
      preference :api_secret, :password

      validates :preferred_measurement_id, :preferred_api_secret, presence: true

      def self.integration_group
        'analytics'
      end

      def self.icon_path
        'integration_icons/google-analytics-logo.png'
      end
    end
  end
end
