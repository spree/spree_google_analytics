module SpreeGoogleAnalytics
  class CheckoutPresenter < OrderPresenter
    def call
      {
        currency: @order.currency,
        value: @order.analytics_subtotal,
        coupon: try_coupon_code,
        items: products(@order)
      }.merge(try_debug_mode)
    end
  end
end
