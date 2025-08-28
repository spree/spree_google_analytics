module Spree
  module Integrations
    class GoogleAnalytics < Spree::Integration
      preference :measurement_id, :string
      preference :google_tag_manager_id, :string
      preference :client, :string, default: 'ga4'

      validates :preferred_measurement_id, presence: true, if: -> { preferred_client == 'ga4' }
      validates :preferred_google_tag_manager_id, presence: true, if: -> { preferred_client == 'gtm' }
      validates :preferred_client, inclusion: { in: %w[ga4 gtm] }

      def self.integration_group
        'analytics'
      end

      def self.icon_path
        'integration_icons/google-analytics-logo.png'
      end
    end
  end
end
