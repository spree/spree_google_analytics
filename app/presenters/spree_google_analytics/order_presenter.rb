module SpreeGoogleAnalytics
  class OrderPresenter
    include Spree::BaseHelper

    def initialize(order:, session_id: nil)
      @order = order
      @session_id = session_id
      @products = products(order)
    end

    def call
      order_subtotal = (@order.item_total + @order.line_items.sum(:promo_total)).to_f

      {
        currency: @order.currency,
        transaction_id: transaction_id,
        value: order_subtotal,
        coupon: try_coupon_code,
        shipping: @order.shipments.sum(&:cost).to_f,
        tax: @order.additional_tax_total&.to_f,
        items: products(@order),
      }.merge(try_suborder_number)
        .merge(try_vendor_order_attributes)
        .merge(try_debug_mode)
        .merge(try_session_id)
        .merge(gift_card_attributes)
    end

    private

    def transaction_id
      @transaction_id ||= if @order.has_attribute?(:parent_id)
                            @order.respond_to?(:parent_order?) && @order.parent_order? ? @order.number : @order.parent.number
                          else
                            @order.number
                          end
    end

    def try_suborder_number
      return {} unless @order.respond_to?(:suborder?) && @order.suborder?

      { suborder_number: @order.number }
    end

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

    def try_vendor_order_attributes
      if defined?(Spree::Vendor) && @order.has_attribute?(:parent_id) && @order.vendor_id && @order.parent_id
        {
          vendor_id: @order.vendor_id,
          vendor_name: @order.vendor.name,
          parent_order_number: @order.parent.number
        }
      else
        {}
      end
    end

    def try_debug_mode
      ENV['GA_DEBUG_MODE'].present? ? { debug_mode: 1 } : {}
    end

    def try_session_id
      @session_id.present? ? { session_id: @session_id } : {}
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
