module Spree
  module Integrations
    class GoogleAnalytics < Spree::Integration
      preference :measurement_id, :string

      validates :preferred_measurement_id, presence: true

      def self.integration_group
        'analytics'
      end

      def self.icon_path
        'integration_icons/google-analytics-logo.png'
      end
    end
  end
end
