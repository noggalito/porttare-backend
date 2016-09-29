require "rails_helper"

RSpec.describe Api::Provider::DispatchersController,
               type: :request do
  describe "non-provider can't use endpoint" do
    let(:user) { create :user }
    before {
      login_as user
      post_with_headers(
        "/api/provider/dispatchers",
        attributes_for(:provider_dispatcher)
      )
    }
    it {
      expect(response.status).to eq(401)
    }
  end

  describe "as provider" do
    let(:provider) { create :user, :provider }
    before { login_as provider }
    let(:attributes) { attributes_for :provider_dispatcher }

    describe "with invalid attributes" do
      let(:invalid_attributes) {
        attributes_for(:provider_dispatcher).except(:email)
      }
      before {
        post_with_headers(
          "/api/provider/dispatchers",
          invalid_attributes
        )
      }

      it "response includes errors" do
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to have_key("email")
      end
    end

    describe "with valid attributes" do
      before do
        expect {
          post_with_headers(
            "/api/provider/dispatchers",
            attributes
          )
        }.to change { ProviderDispatcher.count }.by(1)
      end

      it {
        provider_dispatcher = ProviderDispatcher.last
        expect(
          provider_dispatcher.email
        ).to eq(attributes[:email])
      }
    end
  end
end
