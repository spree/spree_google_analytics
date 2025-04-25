require 'spec_helper'

RSpec.describe Spree::OrdersController do
  render_views

  let(:order) { create(:order_with_totals) }

  describe '#edit' do
    subject(:edit) { get :edit }

    before do
      create(:google_analytics_integration)

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
      expect(response.body).to include("gtag('event', 'view_cart'")
    end
  end
end
