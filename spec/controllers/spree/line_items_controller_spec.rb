require 'spec_helper'

RSpec.describe Spree::LineItemsController do
  render_views

  let(:store) { Spree::Store.default }
  let(:user) { create(:user) }
  let(:order) { create(:order, store: store, user: user) }
  let(:product) { create(:product, stores: [store]) }
  let(:variant) { create(:variant, product: product) }
  let(:line_item) { create(:line_item, order: order, variant: variant) }

  let(:cart_event_data) do
    {
      'currency' => 'USD',
      'value' => cart_event_value,
      'items' => [
        {
          'item_id' => variant.sku,
          'item_name' => variant.product.name,
          'affiliation' => store.name,
          'discount' => 0.0,
          'index' => cart_event_item_index,
          'item_brand' => '',
          'item_category' => '',
          'item_category2' => '',
          'item_category3' => '',
          'item_category4' => '',
          'item_category5' => '',
          'item_list_id' => '',
          'item_list_name' => '',
          'item_variant' => variant.options_text,
          'location_id' => '',
          'price' => cart_event_value,
          'quantity' => 1,
          'coupon' => ''
        }
      ]
    }
  end

  before do
    create(:google_analytics_integration, store: store)

    allow(controller).to receive_messages(try_spree_current_user: user)
    allow(controller).to receive_messages(current_order: order)
    allow(controller).to receive_messages(current_store: store)
  end

  describe '#create' do
    subject(:create_line_item) { post :create, params: { variant_id: variant.id, quantity: 1 }, format: :turbo_stream }

    let(:cart_event_value) { variant.price.to_f }
    let(:cart_event_item_index) { '1' }

    it 'creates line item successfully' do
      expect { create_line_item }.to change(Spree::LineItem, :count).by(1)
    end

    it 'tracks the add to cart event' do
      create_line_item
      expect(response.body).to include("gtag('event', 'add_to_cart', #{cart_event_data.to_json});")
    end
  end

  describe '#destroy' do
    subject(:delete_line_item) { delete :destroy, params: { id: line_item.id }, format: :turbo_stream }

    let(:cart_event_value) { line_item.price.to_f }
    let(:cart_event_item_index) { '' }

    before do
      allow(controller).to receive(:assign_order_with_lock)
      controller.instance_variable_set(:@order, order)
    end

    it 'deletes line item from order' do
      delete_line_item
      expect(order.line_items).not_to include(line_item)
    end

    it 'tracks the remove from cart event' do
      delete_line_item
      expect(response.body).to include("gtag('event', 'remove_from_cart', #{cart_event_data.to_json});")
    end
  end
end
