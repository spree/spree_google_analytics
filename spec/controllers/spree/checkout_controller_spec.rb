require 'spec_helper'

RSpec.describe Spree::CheckoutController do
  render_views

  let(:order) { create(:order_with_totals, user: create(:user)) }
  let(:line_item) { order.line_items.first }

  let(:item_data) do
    {
      'item_id' => line_item.variant.sku,
      'item_name' => line_item.variant.product.name,
      'affiliation' => Spree::Store.default.name,
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
      'item_variant' => '',
      'location_id' => '',
      'price' => line_item.price.to_f,
      'quantity' => line_item.quantity,
      'coupon' => ''
    }
  end

  before do
    create(:google_analytics_integration)

    allow(controller).to receive(:spree_current_user).and_return(order.user)
    allow(controller).to receive(:spree_login_path).and_return('/login')
  end

  describe '#edit' do
    subject(:edit) { get :edit, params: params }

    let(:params) { { state: 'address', token: order.token } }

    let(:begin_checkout_event_data) do
      {
        'currency' => 'USD',
        'value' => 0.0,
        'coupon' => '',
        'items' => [item_data]
      }
    end

    it 'renders the edit page' do
      edit
      expect(response).to render_template(:edit)
    end

    it 'tracks the checkout started event' do
      edit
      expect(response.body).to include("gtag('event', 'begin_checkout', #{begin_checkout_event_data.to_json});")
    end

    context 'when on the cart state' do
      let(:params) { { token: order.token } }

      it 'redirects to the address state' do
        edit
        expect(response).to redirect_to(spree.checkout_state_path(order.token, 'address'))
      end

      it 'sets the checkout started in session' do
        edit
        expect(session[:checkout_started]).to be(true)
      end
    end

    context 'when completed the delivery step' do
      let(:params) { { state: 'payment', token: order.token } }

      let(:order) { create(:order_with_line_items, user: create(:user), state: 'payment') }
      let(:shipping_method) { order.shipments.first.shipping_method }

      let(:add_shipping_info_event_data) do
        {
          'currency' => 'USD',
          'value' => order.item_total.to_f,
          'coupon' => '',
          'items' => [begin_checkout_event_data['items'].first],
          'shipping_tier' => shipping_method.name
        }
      end

      before do
        session[:checkout_step_completed] = 'delivery'
      end

      it 'tracks the add shipping info event' do
        edit
        expect(response.body).to include("gtag('event', 'add_shipping_info', #{add_shipping_info_event_data.to_json});")
      end
    end
  end

  describe '#complete' do
    subject(:complete) { get :complete, params: { token: order.token } }

    let(:order) { create(:completed_order_with_totals, payments: [payment]) }
    let(:payment) { create(:payment) }

    let(:add_payment_info_event_data) do
      {
        'currency' => 'USD',
        'value' => order.item_total.to_f,
        'coupon' => '',
        'items' => [item_data],
        'payment_type' => payment.payment_method.name
      }
    end

    let(:purchase_event_data) do
      {
        'currency' => 'USD',
        'transaction_id' => order.number,
        'value' => order.item_total.to_f,
        'coupon' => '',
        'shipping' => order.ship_total.to_f,
        'tax' => order.tax_total.to_f,
        'items' => [item_data]
      }
    end

    let(:user_properties_event_data) do
      {
        'sign_in_count' => order.user.sign_in_count,
        'created_at' => order.user.created_at.iso8601,
        'completed_orders_count' => order.user.orders.complete.count,
        'completed_orders_total' => order.user.orders.complete.sum(:total).to_f
      }
    end

    before do
      session[:checkout_completed] = true
    end

    it 'renders the complete page' do
      complete
      expect(response).to render_template(:complete)
    end

    it 'renders the checkout complete google analytics partial' do
      complete
      expect(response).to render_template(partial: 'spree_google_analytics/_checkout_complete')
    end

    it 'tracks the add payment info event' do
      complete
      expect(response.body).to include("gtag('event', 'add_payment_info', #{add_payment_info_event_data.to_json});")
    end

    it 'tracks the purchase event' do
      complete
      expect(response.body).to include("gtag('event', 'purchase', #{purchase_event_data.to_json});")
    end

    it 'tracks the user id' do
      complete
      expect(response.body).to include("gtag('set', 'user_id', \"#{order.user_id}\")")
    end

    it 'tracks the user properties' do
      complete
      expect(response.body).to include("gtag('set', 'user_properties', #{user_properties_event_data.to_json});")
    end

    it 'clears out the session' do
      complete
      expect(session[:checkout_completed]).to be_nil
    end
  end
end
