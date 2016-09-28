require "rails_helper"

RSpec.describe Api::Provider::DispatchersController,
               type: :request do
  describe "as non-provider" do
    let(:user) { create :user }
    before {
      login_as user
      get_with_headers "/api/provider/dispatchers"
    }
    it "says I'm not authorised" do
      expect(response.status).to eq(401)
    end
  end

  describe "as provider" do
    let(:provider) { create :user, :provider }
    before { login_as provider }

    describe "lists my dispatchers" do
      let!(:provider_dispatcher) {
        create :provider_dispatcher,
               user: provider
      }
      let!(:other_provider_dispatcher) {
        create :provider_dispatcher
      }

      before {
        get_with_headers "/api/provider/dispatchers"
      }

      let(:json) {
        JSON.parse response.body
      }

      it "response includes my item" do
        binding.pry
        my_dispatcher = json["provider_dispatchers"].detect do |item|
          item["id"] == provider_dispatcher.id
        end
        expect(my_dispatcher).to be_present
      end

      it "response doesn't include other's item" do
        another_dispatcher = json["provider_dispatchers"].detect do |item|
          item["id"] == another_dispatcher.id
        end
        expect(another_dispatcher).to_not be_present
      end
    end
  end
end
