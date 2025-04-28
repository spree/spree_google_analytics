Rails.application.config.after_initialize do
  Rails.application.config.spree.integrations << Spree::Integrations::GoogleAnalytics

  if Rails.application.config.respond_to?(:spree_storefront)
    Rails.application.config.spree_storefront.head_partials << 'spree_google_analytics/head'
    Rails.application.config.spree_storefront.body_end_partials << 'spree_google_analytics/body_end'

    Rails.application.config.spree_storefront.cart_partials << 'spree_google_analytics/cart'
    Rails.application.config.spree_storefront.add_to_cart_partials << 'spree_google_analytics/add_to_cart'
    Rails.application.config.spree_storefront.remove_from_cart_partials << 'spree_google_analytics/remove_from_cart'

    Rails.application.config.spree_storefront.checkout_complete_partials << 'spree_google_analytics/checkout_complete'

    Rails.application.config.spree_storefront.product_partials << 'spree_google_analytics/product'
    Rails.application.config.spree_storefront.add_to_wishlist_partials << 'spree_google_analytics/add_to_wishlist'
  end
end
