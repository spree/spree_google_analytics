module SpreeGoogleAnalytics
  class OrderRefundedPresenter < OrderPresenter
    def initialize(order:, refund:, amount:, session_id: nil)
      @order = order
      @session_id = session_id
      @refund = refund
      @amount = amount
    end

    def call
      super.merge({ value: @amount.to_f })
    end

    private

    def transaction_id
      @transaction_id ||= "#{super}-refund-#{@refund.id}"
    end

    def products(order)
      @products ||= if @refund.reimbursement.present?
                      @refund.
                        reimbursement.
                        return_items.
                        includes(inventory_unit: { line_item: { product: [:taxons] } }, exchange_variant: :product).
                        map(&method(:return_item_to_product_presenter))
                    elsif order.canceled?
                      order.
                        line_items.
                        includes(variant: { product: [:taxons] }).
                        map.with_index(&method(:line_item_to_product_presenter))
                    else
                      []
                    end
    end

    def line_item_to_product_presenter(line_item, index)
      SpreeGoogleAnalytics::ProductPresenter.new(
        resource: line_item,
        quantity: line_item.quantity,
        position: index + 1
      ).call
    end

    def return_item_to_product_presenter(return_item)
      SpreeGoogleAnalytics::ProductPresenter.new(
        resource: return_item.line_item,
        quantity: return_item.return_quantity
      ).call
    end

    def should_attach_gift_card?
      false
    end
  end
end
