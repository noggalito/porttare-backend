require "rails_helper"

RSpec.describe Api::LocationsController,
               type: :request do
  let(:user) { create :user }
  before { login_as user }

  describe "registers new location for user" do
    it {
      expect {
        post_with_headers(
          "/api/locations",
          attributes_for(:user_location)
        )
      }.to change {
        user.locations.count
      }.by(1)
    }
  end

  describe "includes some old locations" do
    let!(:old_location) {
      create :user_location,
             user: user,
             lat: "-4.7921345",
             lon: "73.4321424"
    }
    before {
      post_with_headers(
        "/api/locations",
        attributes_for(:user_location)
      )
    }
    let(:previous_locations) {
      JSON.parse(response.body)["previous_locations"]
    }

    it "includes only old location" do
      expect(previous_locations.count).to eq(1)
    end

    %w(lat lon).each do |attribute|
      it "matches #{attribute}" do
        expect(
          previous_locations.last.fetch(attribute)
        ).to eq(old_location.send(attribute))
      end
    end
  end

  describe "says if the location changed" do

  end
end
