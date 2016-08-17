require "rails_helper"

RSpec.describe Api::Provider::ItemsController,
               type: :request do
  describe "as provider" do
    let(:provider) { create :user, :provider }
    before { login_as provider }

    describe "update my item" do
      let(:my_item) {
        create :provider_item,
               provider_profile: provider.provider_profile
      }

      let(:new_attributes) {
        attributes_for :provider_item
      }

      before {
        put_with_headers(
          "/api/provider/items/#{my_item.id}",
          new_attributes
        )
      }

      it {
        binding.pry
      }
    end

    describe "can't update other provider's item" do
      let(:other_item) {
        create :provider_item
      }
    end
  end
end
