require 'spec_helper'

RSpec.describe SpreeGoogleAnalytics::OrderPresenter do
  subject(:presented_order) { described_class.new(order: order).call }

  let(:order) { create(:order_ready_to_ship, item_total: 10) }
  let(:line_item) { order.line_items.first }

  before do
    line_item.update_column(:promo_total, 5)
  end

  it 'builds the correct data' do
    expect(presented_order).to eq(
      currency: order.currency,
      transaction_id: order.number,
      value: 15,
      tax: order.additional_tax_total&.to_f,
      shipping: order.shipments.sum(&:cost).to_f,
      coupon: order.coupon_code.to_s,
      items: [
        {
          affiliation: Spree::Store.default.name,
          coupon: '',
          discount: 0.0,
          index: '1',
          item_brand: '',
          item_category: '',
          item_category2: '',
          item_category3: '',
          item_category4: '',
          item_category5: '',
          item_id: line_item.variant.sku,
          item_list_id: '',
          item_list_name: '',
          item_name: line_item.name,
          item_variant: '',
          location_id: '',
          price: 10.0,
          quantity: 1
        }
      ]
    )
  end
end
