require "rails_helper"

RSpec.describe Api::Customer::Cart::CheckoutsController,
               type: :request do
  include TimeZoneHelpers

  let(:user) { create :user, :customer }
  before { login_as user }

  describe "submits my order" do
    let(:current_order) {
      create :customer_order,
             customer_profile: user.customer_profile
    }
    let(:order_item) {
      create :customer_order_item,
             customer_order: current_order
    }
    let(:customer_address) {
      create :customer_address,
             customer_profile: user.customer_profile
    }
    let(:customer_billing_address) {
      create :customer_billing_address,
             customer_profile: user.customer_profile
    }
    let(:response_order) {
      JSON.parse(response.body).fetch("customer_order")
    }
    let(:submission_attributes) {
      {
        forma_de_pago: "efectivo",
        observaciones: "something",
        customer_billing_address_id: customer_billing_address.id,
        deliveries_attributes: [ {
          id: current_order.deliveries.first.id,
          provider_profile_id: order_item.provider_item.provider_profile.id,
          delivery_method: "shipping",
          customer_address_id: customer_address.id,
        } ]
      }
    }

    before do
      current_order
      order_item
    end

    describe "invalid - without address" do
      let(:submission_attributes) {
        {
          forma_de_pago: "efectivo",
          customer_billing_address_id: customer_billing_address.id,
          deliveries_attributes: [ {
            id: current_order.deliveries.first.id,
            provider_profile_id: order_item.provider_item.provider_profile.id,
            delivery_method: "shipping",
          } ]
        }
      }

      before do
        post_with_headers(
          "/api/customer/cart/checkout",
          submission_attributes
        )
      end

      it {
        errors = JSON.parse(response.body).fetch("errors")
        expect(errors).to have_key("order_items")
      }
    end

    describe "successful submission" do
      before do
        post_with_headers(
          "/api/customer/cart/checkout",
          submission_attributes
        )
      end

      it "order is persisted" do
        expect(
          response_order["status"]
        ).to eq("submitted")
        expect(
          response_order["observaciones"]
        ).to eq(submission_attributes[:observaciones])
      end
    end

    describe "successful - without address (pickup)" do
      let(:submission_attributes) {
        {
          forma_de_pago: "efectivo",
          customer_billing_address_id: customer_billing_address.id,
          deliveries_attributes: [ {
            id: current_order.deliveries.first.id,
            provider_profile_id: order_item.provider_item.provider_profile.id,
            delivery_method: "pickup"
          } ]
        }
      }

      before do
        post_with_headers(
          "/api/customer/cart/checkout",
          submission_attributes
        )
      end

      it {
        expect(
          response_order["status"]
        ).to eq("submitted")
        response_provider = response_order["provider_profiles"].first
        expect(
          response_provider["customer_order_delivery"]["delivery_method"]
        ).to eq("pickup")
      }
    end

    describe "deliver later" do
      let(:submission_attributes) {
        {
          forma_de_pago: "efectivo",
          observaciones: "something",
          customer_billing_address_id: customer_billing_address.id,
          deliveries_attributes: [ {
            id: current_order.deliveries.first.id,
            provider_profile_id: order_item.provider_item.provider_profile.id,
            delivery_method: "shipping",
            deliver_at: (Time.now + 2.hours).strftime("%Y-%m-%d %H:%M %z"),
            customer_address_id: customer_address.id
          } ]
        }
      }

      before do
        post_with_headers(
          "/api/customer/cart/checkout",
          submission_attributes
        )
      end

      it {
        response_provider = response_order["provider_profiles"].first
        expect(
          response_provider["customer_order_delivery"]["deliver_at"]
        ).to eq(
          formatted_time(
            submission_attributes[:deliveries_attributes].first[:deliver_at]
          )
        )
      }
    end

    describe "grouped by provider profile, can deliver to several addresses & pickup" do
      let(:future_shipping) {
        (Time.now + 2.hours).strftime("%Y-%m-%d %H:%M %z")
      }
      let(:submission_attributes) {
        {
          forma_de_pago: "efectivo",
          customer_billing_address_id: customer_billing_address.id,
          deliveries_attributes: [
            {
              id: current_order.delivery_for_provider(provider_one).id,
              provider_profile_id: provider_one.id,
              delivery_method: "shipping",
              customer_address_id: customer_address.id
            },
            {
              id: current_order.delivery_for_provider(provider_two).id,
              provider_profile_id: provider_two.id,
              delivery_method: "shipping",
              customer_address_id: second_customer_address.id,
              deliver_at: future_shipping
            },
            {
              id: current_order.delivery_for_provider(provider_three).id,
              provider_profile_id: provider_three.id,
              delivery_method: "pickup",
              deliver_at: (Time.now + 3.hours).strftime("%Y-%m-%d %H:%M %z")
            }
          ]
        }
      }
      let(:second_order_item) {
        create :customer_order_item,
               customer_order: current_order
      }
      let(:third_order_item) {
        create :customer_order_item,
               customer_order: current_order
      }
      let(:second_customer_address) {
        create :customer_address,
               customer_profile: user.customer_profile
      }
      let(:provider_one) {
        order_item.provider_item.provider_profile
      }
      let(:provider_two) {
        second_order_item.provider_item.provider_profile
      }
      let(:provider_three) {
        third_order_item.provider_item.provider_profile
      }

      before do
        second_order_item
        third_order_item
        second_customer_address
      end

      it "creates three customer order deliveries" do
        post_with_headers(
          "/api/customer/cart/checkout",
          submission_attributes
        )

        one = response_order["provider_profiles"].detect do |profile|
          profile["id"] == provider_one.id
        end
        expect(
          one["customer_order_delivery"]["customer_address_id"]
        ).to eq(customer_address.id)

        two = response_order["provider_profiles"].detect do |profile|
          profile["id"] == provider_two.id
        end
        expect(
          two["customer_order_delivery"]["deliver_at"]
        ).to eq(
          formatted_time(future_shipping)
        )

        three = response_order["provider_profiles"].detect do |profile|
          profile["id"] == provider_three.id
        end
        expect(
          three["customer_order_delivery"]["delivery_method"]
        ).to eq("pickup")
      end
    end

    describe "discounts" do
      pending
    end
  end
end
