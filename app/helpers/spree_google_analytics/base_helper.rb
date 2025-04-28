module SpreeGoogleAnalytics
  module BaseHelper
    def google_analytics_checkout_json
      return unless @order.present?

      @google_analytics_checkout_json ||= SpreeGoogleAnalytics::CheckoutPresenter.new(order: @order).call.to_json.html_safe
    end

    def google_analytics_add_shipping_info_json(shipment)
      SpreeGoogleAnalytics::CheckoutPresenter.new(order: shipment.order).call.merge({ shipping_tier: shipment.shipping_method&.name }).to_json.html_safe
    end

    def google_analytics_user_properties_json(user)
      return unless user.present?

      {
        sign_in_count: user.sign_in_count,
        created_at: user.created_at&.iso8601.to_s
      }.to_json.html_safe
    end

    def google_analytics_payment_json
      return unless @order.present?

      @google_analytics_payment_json ||= SpreeGoogleAnalytics::PaymentPresenter.new(order: @order).call.to_json.html_safe
    end

    def google_analytics_purchase_json
      return unless @order.present?

      @google_analytics_purchase_json ||= SpreeGoogleAnalytics::OrderPresenter.new(order: @order).call.to_json.html_safe
    end

    def google_analytics_view_item_json(variant = nil)
      variant ||= @selected_variant || @variant_from_options || @product&.default_variant
      return unless variant.present?

      {
        currency: current_currency,
        value: variant.amount_in(current_currency).to_f,
        items: [
          SpreeGoogleAnalytics::ProductPresenter.new(
            store_name: current_store.name,
            resource: variant,
            quantity: 1
          ).call
        ]
      }.to_json.html_safe
    end

    def google_analytics_cart_event_json(line_item, quantity, position)
      {
        currency: line_item.currency,
        value: line_item.amount.to_f,
        items: [
          SpreeGoogleAnalytics::ProductPresenter.new(
            resource: line_item,
            quantity: quantity,
            position: position
          ).call
        ]
      }.to_json.html_safe
    end

    def google_analytics_add_to_wishlist_event_json(variant)
      {
        currency: current_currency,
        value: variant.amount_in(current_currency),
        items: [
          SpreeGoogleAnalytics::ProductPresenter.new(
            store_name: current_store.name,
            resource: variant,
            quantity: 1
          ).call
        ]
      }.to_json.html_safe
    end
  end
end
