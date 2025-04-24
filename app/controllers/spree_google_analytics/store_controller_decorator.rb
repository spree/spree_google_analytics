module SpreeGoogleAnalytics
  module StoreControllerDecorator
    def self.prepended(base)
      base.helper SpreeGoogleAnalytics::BaseHelper
    end
  end
end

Spree::StoreController.prepend(SpreeGoogleAnalytics::StoreControllerDecorator) if defined?(Spree::StoreController)
