require "rails_helper"

RSpec.describe Api::Customer::WishlistsController,
               type: :request do
  let(:user) {
    create :user, :customer
  }
  let(:customer_wishlist) {
    create :customer_wishlist,
           customer_profile: user.customer_profile
  }
  let(:provider_item) {
    create :provider_item
  }

  let(:new_attributes) {
    attributes_for(:customer_wishlist).slice(
      :nombre,
      :entregar_en
    ).merge(provider_items_ids: [provider_item.id])
  }

  before do
    login_as user

    customer_wishlist

    put_with_headers(
      "/api/customer/wishlists/#{customer_wishlist.id}",
      new_attributes
    )
  end

  let(:response_wishlist) {
    JSON.parse(response.body).fetch("customer_wishlist")
  }

  it "desired attributes are updated" do
    expect(
      response_wishlist["nombre"]
    ).to eq(new_attributes[:nombre])

    tz_entregar_en = I18n.l(
      new_attributes[:entregar_en].in_time_zone(
        Rails.application.config.time_zone
      ),
      format: :api
    )
    expect(
      response_wishlist["entregar_en"]
    ).to eq(tz_entregar_en)

    expect(
      customer_wishlist.reload.provider_items_ids
    ).to include(provider_item.id.to_s)
  end
end
