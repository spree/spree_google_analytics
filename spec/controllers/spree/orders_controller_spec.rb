require 'spec_helper'

RSpec.describe Spree::OrdersController do
  render_views

  let(:store) { Spree::Store.default }
  let(:order) { create(:order_with_totals) }
  let(:line_item) { order.line_items.first }

  let(:event_data) do
    {
      'currency' => 'USD',
      'value' => order.item_total.to_f,
      'coupon' => '',
      'items' => [
        {
          'item_id' => line_item.variant.sku,
          'item_name' => line_item.variant.product.name,
          'affiliation' => store.name,
          'discount' => 0.0,
          'index' => '1',
          'item_brand' => '',
          'item_category' => '',
          'item_category2' => '',
          'item_category3' => '',
          'item_category4' => '',
          'item_category5' => '',
          'item_list_id' => '',
          'item_list_name' => '',
          'item_variant' => line_item.variant.options_text,
          'location_id' => '',
          'price' => line_item.price.to_f,
          'quantity' => 1,
          'coupon' => ''
        }
      ]
    }
  end

  describe '#edit' do
    subject(:edit) { get :edit }

    before do
      create(:google_analytics_integration)
      order.update_column(:total, line_item.price)

      allow(controller).to receive(:try_spree_current_user).and_return(order.user)
      allow(controller).to receive(:spree_current_user).and_return(order.user)
      allow(controller).to receive(:current_order).and_return(order)
    end

    it 'renders the edit template' do
      edit
      expect(response).to render_template(:edit)
    end

    it 'tracks the view cart event' do
      edit
      expect(response.body).to include("gtag('event', 'view_cart', #{event_data.to_json});")
    end
  end
end
