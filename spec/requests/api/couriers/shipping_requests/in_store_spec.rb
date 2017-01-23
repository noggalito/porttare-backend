require "rails_helper"

RSpec.describe Api::Courier::ShippingRequestsController,
               type: :request do
  describe "I can take pending shipping requests" do
    let(:user) { create :user, :courier }

    let(:shipping_request) {
      create :shipping_request,
             :for_customer_order_delivery,
             address_attributes: { direccion: "something" }
    }

    before do
      login_as user
      shipping_request
      post_with_headers "/api/courier/shipping_requests/#{shipping_request.id}/in_store"
    end

    it "includes shipping request" do
      response_request = JSON.parse(response.body).fetch("shipping_request")

      expect(
        response_request["status"]
      ).to eq("in_progress")
    end
  end
end
