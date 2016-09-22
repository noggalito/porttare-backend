require "rails_helper"

RSpec.describe Api::Provider::ProfilesController,
               type: :request do
  let(:user) { create :user }
  before { login_as user }

  describe "doesn't create provider profile for user" do
    let(:invalid_attributes) {
      # without a required attribute
      attributes_for(:provider_profile).except(:ruc)
    }
    before {
      post_with_headers("/api/provider/profile", invalid_attributes)
    }

    it {
      expect(user.reload.provider_profile).to be_nil
    }
    it {
      json_response = JSON.parse(response.body)
      expect(json_response["errors"]["ruc"]).to be_present
    }
  end

  describe "creates valid provider profile for user" do
    before do
      post_with_headers(
        "/api/provider/profile",
        attributes_for(:provider_profile)
      )
    end

    it {
      provider_profile = ProviderProfile.last
      expect(provider_profile.user).to eq(user)
    }
  end

  describe "already provider" do
    let(:user) { create :user, :provider }

    before do
      expect {
        post_with_headers(
          "/api/provider/profile",
          attributes_for(:provider_profile)
        )
      }.to_not change(ProviderProfile, :count)
    end

    it "gets halt and response by pundit" do
      expect(
        JSON.parse(response.body)
      ).to have_key("error")
    end
  end

  describe "persists provider branches" do
    let(:direccion) { Faker::Address.street_address }

    let(:attributes) {
      attributes_for(:provider_profile).merge(
        offices_attributes: [
          { direccion: direccion, horario: "09:00-18:00" }
        ]
      )
    }

    before do
      expect {
        post_with_headers(
          "/api/provider/profile",
          attributes
        )
      }.to change{ ProviderOffice.count }.by(1)
    end

    it {
      provider_office = ProviderOffice.last
      expect(provider_office.direccion).to eq(direccion)
      expect(
        provider_office.provider_profile
      ).to eq(user.provider_profile)
    }
  end
end
