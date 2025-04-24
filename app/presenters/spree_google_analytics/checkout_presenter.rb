module SpreeGoogleAnalytics
  class CheckoutPresenter < OrderPresenter
    def call
      {
        currency: @order.currency,
        value: @order.total&.to_f,
        coupon: try_coupon_code,
        items: products(@order)
      }.merge(try_debug_mode).
        merge(try_session_id)
    end
  end
end
