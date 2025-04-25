require 'spec_helper'

RSpec.describe Spree::Account::WishedItemsController, type: :controller do
  render_views

  let(:variant) { create(:variant, price: 19.99) }
  let(:user) { create(:user) }
  let(:wishlist) { create(:wishlist, user: user, is_default: true) }

  before do
    create(:google_analytics_integration)

    allow(controller).to receive(:current_store).and_return(Spree::Store.default)
    allow(controller).to receive(:spree_login_path).and_return('/login')
    allow(controller).to receive(:try_spree_current_user).and_return(user)
    allow(controller).to receive(:current_wishlist).and_return(wishlist)
  end

  describe '#create' do
    subject(:create_wished_item) { post :create, params: { wished_item: { variant_id: variant.id } }, format: :turbo_stream }

    let(:event_data) do
      {
        'currency' => 'USD',
        'value' => '19.99',
        'items' => [
          {
            'item_id' => variant.sku,
            'item_name' => variant.product.name,
            'affiliation' => Spree::Store.default.name,
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
            'item_variant' => variant.options_text,
            'location_id' => '',
            'price' => variant.price.to_f,
            'quantity' => 1
          }
        ]
      }
    end

    it 'adds a wished item to the wishlist' do
      expect { create_wished_item }.to change(Spree::WishedItem, :count).by(1)
    end

    it 'tracks the add to wishlist event' do
      create_wished_item
      expect(response.body).to include(
        "gtag('event', 'add_to_wishlist', #{event_data.to_json});"
      )
    end
  end
end
