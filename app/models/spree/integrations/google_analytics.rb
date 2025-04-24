# == Schema Information
#
# Table name: spree_integrations
#
#  id          :bigint           not null, primary key
#  active      :boolean          default(FALSE), not null
#  preferences :text
#  type        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  project_id  :bigint           not null
#  store_id    :bigint           not null
#
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
