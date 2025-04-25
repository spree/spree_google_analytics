require 'spec_helper'

RSpec.describe Spree::ProductsController do
  render_views

  before do
    create(:google_analytics_integration)
  end

  describe '#show' do
    subject(:show) { get :show, params: { id: product.slug } }

    let(:product) { create(:product, stores: [Spree::Store.default]) }

    it 'renders the product page' do
      show
      expect(response).to render_template(:show)
    end

    it 'renders the product google analytics partial' do
      show
      expect(response.body).to render_template(partial: 'spree_google_analytics/_product')
    end

    it 'tracks the product view event' do
      show
      expect(response.body).to include("gtag('event', 'view_item'")
    end
  end
end
