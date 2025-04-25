require 'spec_helper'

RSpec.describe Spree::CheckoutController do
  render_views

  let(:order) { create(:order_with_totals, user: create(:user)) }

  before do
    create(:google_analytics_integration)

    allow(controller).to receive(:spree_current_user).and_return(order.user)
    allow(controller).to receive(:spree_login_path).and_return('/login')
  end

  describe '#edit' do
    subject(:edit) { get :edit, params: params }

    let(:params) { { state: 'address', token: order.token } }

    it 'renders the edit page' do
      edit
      expect(response).to render_template(:edit)
    end

    it 'tracks the checkout started event' do
      edit
      expect(response.body).to include("gtag('event', 'begin_checkout'")
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

      before do
        session[:checkout_step_completed] = 'delivery'
      end

      it 'tracks the add shipping info event' do
        edit
        expect(response.body).to include("gtag('event', 'add_shipping_info'")
      end
    end
  end

  describe '#complete' do
    subject(:complete) { get :complete, params: { token: order.token } }

    let(:order) { create(:completed_order_with_totals) }

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
      expect(response.body).to include("gtag('event', 'add_payment_info'")
    end

    it 'tracks the purchase event' do
      complete
      expect(response.body).to include("gtag('event', 'purchase'")
    end

    it 'tracks the user id' do
      complete
      expect(response.body).to include("gtag('set', { user_id: \"#{order.user_id}\" })")
    end

    it 'clears out the session' do
      complete
      expect(session[:checkout_completed]).to be_nil
    end
  end
end
