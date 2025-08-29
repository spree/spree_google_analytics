module SpreeGoogleAnalytics
  module BaseHelper
    def google_analytics_client_type
      @google_analytics_client_type ||= store_integration('google_analytics')&.preferred_client
    end

    def use_gtm?
      google_analytics_client_type == 'gtm'
    end

    def google_analytics_add_shipping_info_json(shipment)
      SpreeGoogleAnalytics::CheckoutPresenter.new(order: shipment.order).call.merge({ shipping_tier: shipment.shipping_method&.name }).to_json.html_safe
    end

    def google_analytics_user_properties_json(user)
      return unless user.present?

      {
        sign_in_count: user.sign_in_count,
        created_at: user.created_at&.iso8601.to_s,
        completed_orders_count: user.orders.complete.count,
        completed_orders_total: user.orders.complete.sum(:total).to_f
      }.to_json.html_safe
    end



    def google_analytics_view_item_json(variant = nil)
      variant ||= @selected_variant || @variant_from_options || @product&.default_variant
      return unless variant.present?

      if use_gtm?
        google_analytics_gtm_view_item_json(variant)
      else
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
    end

    def google_analytics_gtm_view_item_json(variant)
      {
        event: 'view_item',
        ecommerce: {
          currency: current_currency,
          value: variant.amount_in(current_currency).to_f,
          items: [
            SpreeGoogleAnalytics::ProductPresenter.new(
              store_name: current_store.name,
              resource: variant,
              quantity: 1
            ).call
          ]
        }
      }.to_json.html_safe
    end

    def google_analytics_cart_event_json(line_item, quantity, position)
      if use_gtm?
        google_analytics_gtm_cart_event_json(line_item, quantity, position)
      else
        {
          currency: line_item.currency,
          value: line_item.amount,
          items: [
            SpreeGoogleAnalytics::ProductPresenter.new(
              resource: line_item,
              quantity: quantity,
              position: position
            ).call
          ]
        }.to_json.html_safe
      end
    end

    def google_analytics_gtm_cart_event_json(line_item, quantity, position)
      {
        event: 'add_to_cart',
        ecommerce: {
          currency: line_item.currency,
          value: line_item.amount,
          items: [
            SpreeGoogleAnalytics::ProductPresenter.new(
              resource: line_item,
              quantity: quantity,
              position: position
            ).call
          ]
        }
      }.to_json.html_safe
    end

    def google_analytics_remove_from_cart_event_json(line_item, quantity, position)
      if use_gtm?
        google_analytics_gtm_remove_from_cart_event_json(line_item, quantity, position)
      else
        google_analytics_cart_event_json(line_item, quantity, position)
      end
    end

    def google_analytics_gtm_remove_from_cart_event_json(line_item, quantity, position)
      {
        event: 'remove_from_cart',
        ecommerce: {
          currency: line_item.currency,
          value: line_item.amount.to_f,
          items: [
            SpreeGoogleAnalytics::ProductPresenter.new(
              resource: line_item,
              quantity: quantity,
              position: position
            ).call
          ]
        }
      }.to_json.html_safe
    end

    def google_analytics_add_to_wishlist_event_json(variant)
      if use_gtm?
        google_analytics_gtm_add_to_wishlist_event_json(variant)
      else
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

    def google_analytics_gtm_add_to_wishlist_event_json(variant)
      {
        event: 'add_to_wishlist',
        ecommerce: {
          currency: current_currency,
          value: variant.amount_in(current_currency),
          items: [
            SpreeGoogleAnalytics::ProductPresenter.new(
              store_name: current_store.name,
              resource: variant,
              quantity: 1
            ).call
          ]
        }
      }.to_json.html_safe
    end

    def google_analytics_checkout_json
      return unless @order.present?

      if use_gtm?
        google_analytics_gtm_checkout_json
      else
        @google_analytics_checkout_json ||= SpreeGoogleAnalytics::CheckoutPresenter.new(order: @order).call.to_json.html_safe
      end
    end

    def google_analytics_gtm_checkout_json
      @google_analytics_gtm_checkout_json ||= {
        event: 'begin_checkout',
        ecommerce: SpreeGoogleAnalytics::CheckoutPresenter.new(order: @order).call
      }.to_json.html_safe
    end

    def google_analytics_purchase_json
      return unless @order.present?

      if use_gtm?
        google_analytics_gtm_purchase_json
      else
        @google_analytics_purchase_json ||= SpreeGoogleAnalytics::OrderPresenter.new(order: @order).call.to_json.html_safe
      end
    end

    def google_analytics_gtm_purchase_json
      @google_analytics_gtm_purchase_json ||= {
        event: 'purchase',
        ecommerce: SpreeGoogleAnalytics::OrderPresenter.new(order: @order).call
      }.to_json.html_safe
    end

    def google_analytics_payment_json
      return unless @order.present?

      if use_gtm?
        google_analytics_gtm_payment_json
      else
        @google_analytics_payment_json ||= SpreeGoogleAnalytics::PaymentPresenter.new(order: @order).call.to_json.html_safe
      end
    end

    def google_analytics_gtm_payment_json
      @google_analytics_gtm_payment_json ||= {
        event: 'add_payment_info',
        ecommerce: SpreeGoogleAnalytics::PaymentPresenter.new(order: @order).call
      }.to_json.html_safe
    end

    def google_analytics_view_cart_json
      return unless @order.present?

      if use_gtm?
        google_analytics_gtm_view_cart_json
      else
        @google_analytics_checkout_json ||= SpreeGoogleAnalytics::CheckoutPresenter.new(order: @order).call.to_json.html_safe
      end
    end

    def google_analytics_gtm_view_cart_json
      @google_analytics_gtm_view_cart_json ||= {
        event: 'view_cart',
        ecommerce: SpreeGoogleAnalytics::CheckoutPresenter.new(order: @order).call
      }.to_json.html_safe
    end
  end
end
