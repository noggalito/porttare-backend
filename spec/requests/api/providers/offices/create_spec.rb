require "rails_helper"

RSpec.describe Api::Provider::OfficesController,
               type: :request do
  describe "non-provider" do
    let(:user) { create :user }
    before do
      login_as user
      post_with_headers(
        "/api/provider/offices",
        attributes_for(:provider_office)
      )
    end
    it { expect(response.status).to eq(401) }
  end

  describe "as provider" do
    let(:provider) { create :user, :provider }

    before { login_as provider }

    describe "can create offices" do
      let(:attributes) {
        # only required ones
        attributes_for(:provider_office).slice(
          :telefono,
          :direccion,
          :hora_de_cierre,
          :hora_de_apertura
        )
      }

      before do
        expect {
          post_with_headers(
            "/api/provider/offices",
            attributes
          )
        }.to change { ProviderOffice.count }.by(1)
      end

      it "gets assigned to the right provider" do
        office = ProviderOffice.last
        expect(
          office.provider_profile
        ).to eq(provider.provider_profile)
      end

      it "response" do
        binding.pry
        json = JSON.parse(response.body)

        expect(
          json["direccion"]
        ).to eq(attributes[:direccion])

        expect(
          json["hora_de_apertura"]
        ).to eq(attributes[:hora_de_apertura])
      end
    end
  end
end
