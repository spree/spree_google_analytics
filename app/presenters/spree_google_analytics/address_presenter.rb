module SpreeGoogleAnalytics
  class AddressPresenter
    # @param address [Spree::Address]
    def initialize(address:)
      @address = address
    end

    # @return [Hash]
    def call
      return {} if @address.nil?

      {
        city: @address.city,
        country: @address.country_name,
        postal_code: @address.zipcode,
        state: @address.state_text,
        street: @address.street
      }
    end
  end
end
