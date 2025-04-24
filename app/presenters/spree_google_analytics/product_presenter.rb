module SpreeGoogleAnalytics
  class ProductPresenter
    include Spree::BaseHelper
    include Spree::ProductsHelper

    # @param resource [Spree::LineItem, Spree::Variant]
    # @param quantity [Integer]
    # @param position [Integer]
    # @param store_name [String]
    def initialize(resource:, quantity:, position: nil, store_name: nil)
      @resource = resource
      @quantity = quantity
      @position = position
      @store_name = store_name
    end

    # @return [Hash]
    def call
      {
        item_id: @resource.sku.presence || @resource.product_id,
        item_name: @resource.name,
        affiliation: @resource.respond_to?(:order) ? @resource.order.store.name : @store_name,
        discount: 0.00,
        index: @position.to_s,
        item_brand: brand_name(@resource.product).to_s,
        item_category: taxons[0].to_s,
        item_category2: taxons[1].to_s,
        item_category3: taxons[2].to_s,
        item_category4: taxons[3].to_s,
        item_category5: taxons[4].to_s,
        item_list_id: '',
        item_list_name: '',
        item_variant: @resource.try(:options_text),
        location_id: '',
        price: @resource.price.to_f,
        quantity: @quantity
      }.merge(try_promotion_codes_applied_to_line_item)
    end

    private

    def try_promotion_codes_applied_to_line_item
      return {} if @resource.class != Spree::LineItem

      { coupon: @resource.adjustments.promotion.map do |adjustment|
        adjustment.source.promotion.code
      end.compact.uniq.join(',') }
    end

    def taxons
      @taxons ||= @resource.product.main_taxon&.pretty_name.to_s.split('->').map(&:strip)
    end
  end
end
