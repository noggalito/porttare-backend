require "rails_helper"

RSpec.describe Api::ProvidersController,
               type: :request do
  let(:user) { create :user }
  before { login_as user }

  describe "provider information with your products" do
    let(:category) { create :provider_category }

    let(:provider_profile){
      create :provider_profile,
             provider_category: category
    }

    let(:provider_product) {
      create :provider_item,
             provider_profile: provider_profile
    }

    let(:provider_office) {
      create :provider_office,
             provider_profile: provider_profile
    }

    before do
      provider_profile
      provider_product
      provider_office
      get_with_headers "/api/categories/#{category.id}/providers/#{provider_profile.id}"
    end

    let(:json) {
      JSON.parse response.body
    }

    let(:provider_from_response) {
      providers = json["provider"]
    }

    let(:products_from_response) {
      products = provider_from_response["products"]
    }

    let(:other_provider_product) {
      create :provider_item
    }

    it "should include provider products" do
      expect(products_from_response).to be_present
    end

    it "response doesn't include other's products" do
      others_products = products_from_response.detect do |item|
        item["id"] == other_provider_product.id
      end
      expect(others_products).to_not be_present
    end

    it "includes info for provider offices" do
      expect(
        provider_from_response["offices"].first
      ).to have_key("horario")
    end

    it "doesn't include full provider info" do
      expect(
        provider_from_response
      ).to_not have_key("banco_identificacion")
    end
  end
end
