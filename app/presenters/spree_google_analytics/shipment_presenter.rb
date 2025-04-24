module SpreeGoogleAnalytics
  class ShipmentPresenter < OrderPresenter
    def initialize(order:, shipment:)
      @order = order
      @shipment = shipment
    end

    def call
      {
        order_number: @order.number,
        shipping_method: @shipment.shipping_method&.name.to_s,
        tracking: @shipment&.tracking.to_s,
        tracking_url: @shipment&.tracking_url.to_s,
        cost: @shipment.final_price.to_f
      }.merge(try_vendor_order_attributes).
        merge(try_debug_mode)
    end
  end
end
