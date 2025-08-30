module SpreeGoogleAnalytics
  module StoreControllerDecorator
    def self.prepended(base)
      base.helper SpreeGoogleAnalytics::BaseHelper
    end
  end
end

Spree::StoreController.prepend(SpreeGoogleAnalytics::StoreControllerDecorator) if defined?(Spree::StoreController)

# include in Devise controllers
if defined?(Spree::UserSessionsController)
  Spree::UserSessionsController.prepend(SpreeGoogleAnalytics::UserSessionsControllerDecorator)
end
if defined?(Spree::UserRegistrationsController)
  Spree::UserRegistrationsController.prepend(SpreeGoogleAnalytics::UserRegistrationsControllerDecorator)
end
if defined?(Spree::UserPasswordsController)
  Spree::UserPasswordsController.prepend(SpreeGoogleAnalytics::UserPasswordsControllerDecorator)
end
