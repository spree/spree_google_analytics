module SpreeGoogleAnalytics
  class OrderPresenter
    include Spree::BaseHelper

    def initialize(order:)
      @order = order
      @products = products(order)
    end

    def call
      {
        currency: @order.currency,
        transaction_id: @order.number,
        value: @order.analytics_subtotal,
        coupon: try_coupon_code,
        shipping: @order.shipment_total.to_f,
        tax: @order.additional_tax_total.to_f,
        items: products(@order)
      }.merge(try_debug_mode)
        .merge(gift_card_attributes)
    end

    private

    def products(order)
      return [] if order.line_items.empty?

      product_includes = %i[taxons]
      product_includes << :vendor if defined?(Spree::Vendor)

      @products ||= order.line_items.includes(variant: { product: product_includes }).map.with_index do |line_item, index|
        ProductPresenter.new(
          resource: line_item,
          quantity: line_item.quantity,
          position: index + 1
        ).call
      end
    end

    def try_debug_mode
      ENV['GA_DEBUG_MODE'].present? ? { debug_mode: 1 } : {}
    end

    def try_coupon_code
      (@order.coupon_code || @order.try(:gift_card).try(:code)).to_s
    end

    def should_attach_gift_card?
      true
    end

    def gift_card_attributes
      return {} unless should_attach_gift_card?
      return {} unless defined?(Spree::GiftCard)

      {
        gift_card_code: @order.gift_card&.code.to_s.upcase,
        gift_card_amount: @order.gift_card_total.to_f,
        gift_card_balance: @order.gift_card&.amount_remaining.to_f,
        total_minus_store_credits: @order.total_minus_store_credits.to_f,
      }
    end
  end
end
