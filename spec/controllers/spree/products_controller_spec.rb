require 'spec_helper'

RSpec.describe Spree::ProductsController do
  render_views

  let(:store){ Spree::Store.default }
  let(:product) { create(:product, stores: [store]) }

  let(:event_data) do
    {
      'currency' => 'USD',
      'value' => product.price.to_f,
      'items' => [
        {
          'item_id' => product.sku,
          'item_name' => product.name,
          'affiliation' => store.name,
          'discount' => 0.0,
          'index' => '',
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
          'price' => product.price.to_f,
          'quantity' => 1
        }
      ]
    }
  end

  before do
    create(:google_analytics_integration)
  end

  describe '#show' do
    subject(:show) { get :show, params: { id: product.slug } }

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
      expect(response.body).to include("gtag('event', 'view_item', #{event_data.to_json});")
    end
  end
end
