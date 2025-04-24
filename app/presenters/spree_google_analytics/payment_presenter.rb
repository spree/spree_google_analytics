module SpreeGoogleAnalytics
  class PaymentPresenter < CheckoutPresenter
    def call
      super.merge({ payment_type: @order.payments&.last&.payment_method&.name })
    end
  end
end
