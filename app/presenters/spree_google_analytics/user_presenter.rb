module SpreeGoogleAnalytics
  class UserPresenter
    def initialize(user:)
      @user = user
      @address = @user&.address
    end

    def call
      return {} if @user.nil?

      {
        email: @user.email,
        name: @user.name,
        logins: @user.sign_in_count,
        created_at: @user.created_at&.iso8601.to_s,
        first_name: @user.first_name,
        last_name: @user.last_name,
        phone: @user.phone
      }.merge(try_address)
    end

    private

    def try_address
      AddressPresenter.new(address: @address).call
    end
  end
end
