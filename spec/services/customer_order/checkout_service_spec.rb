require 'rails_helper'

describe CustomerOrder::CheckoutService,
         type: :model do
  let(:checkout_attributes) { {} }
  let(:user) { customer_order.customer_profile.user }
  let(:customer_order) {
    create :customer_order, :with_order_item
  }

  subject {
    described_class.new(
      user,
      customer_order,
      checkout_attributes
    )
  }

  describe "invalid" do
    describe "without any items" do
      let(:customer_order) { create :customer_order }
      it {
        is_expected.to_not be_valid
        expect(
          subject.errors[:order_items]
        ).to be_present
      }
    end

    describe "with an invalid order item" do
      let(:customer_order_item) {
        create :customer_order_item,
               customer_order: customer_order
      }
      before {
        customer_order_item
        customer_order_item.update_column :cantidad, -1
      }
      it {
        is_expected.to_not be_valid
        expect(
          subject.errors[:order_items]
        ).to be_present
      }
    end

    describe "without required attributes" do
      it {
        is_expected.to_not be_valid
        expect(
          subject.errors.messages
        ).to have_key(:forma_de_pago)
        expect(
          subject.errors.messages
        ).to have_key(:delivery_method)
        expect(
          subject.errors.messages
        ).to have_key(:customer_address_id)
        expect(
          subject.errors.messages
        ).to have_key(:customer_billing_address_id)
      }
    end

    describe "submitted order" do
      let(:customer_order) { create :customer_order, :submitted }
      it {
        is_expected.to_not be_valid
        expect(subject.errors).to have_key(:status)
      }
    end

    describe "another user's order" do
      let(:user) { create :user, :customer }
      it {
        is_expected.to_not be_valid
        expect(subject.errors).to have_key(:status)
      }
    end

    describe "wrong delivery_method" do
      let(:checkout_attributes) {
        {
          delivery_method: "none",
          forma_de_pago: "efectivo",
          customer_address_id: 1,
          customer_billing_address_id: 1
        }
      }
      it {
        is_expected.to_not be_valid
        expect(
          subject.errors.messages[:base].join
        ).to include("delivery_method")
      }
    end

    describe "wrong forma_de_pago" do
      let(:checkout_attributes) {
        {
          forma_de_pago: "free",
          delivery_method: "shipping",
          customer_address_id: 1,
          customer_billing_address_id: 1
        }
      }
      it {
        is_expected.to_not be_valid
        expect(
          subject.errors.messages[:base].join
        ).to include("forma_de_pago")
      }
    end

    describe "another user's addresses" do
      let(:customer_address) { create :customer_address }
      let(:customer_billing_address) { create :customer_billing_address }
      let(:checkout_attributes) {
        {
          customer_address_id: customer_address.id,
          customer_billing_address_id: customer_billing_address.id,
          forma_de_pago: "efectivo",
          delivery_method: "shipping"
        }
      }
      it {
        is_expected.to_not be_valid
        expect(subject.errors).to have_key(:customer_address_id)
        expect(subject.errors).to have_key(:customer_billing_address_id)
      }
    end
  end

  describe "delivery_method" do
    describe "shipping" do
      let(:customer_address) {
        create :customer_address,
               customer_profile: user.customer_profile
      }
      let(:customer_billing_address) {
        create :customer_billing_address,
               customer_profile: user.customer_profile
      }
      let(:checkout_attributes) {
        {
          forma_de_pago: "efectivo",
          delivery_method: "shipping",
          customer_address_id: customer_address.id,
          customer_billing_address_id: customer_billing_address.id,
          observaciones: "some stuff"
        }
      }

      it { is_expected.to be_valid }

      describe "when saving" do
        before { expect(subject.save).to be_truthy }

        it "marks as submitted" do
          expect(
            customer_order.reload
          ).to be_submitted
        end

        it "caches addresses" do
          expect(
            customer_order.reload.customer_address_attributes
          ).to be_present
          expect(
            customer_order.reload.customer_billing_address_attributes
          ).to be_present
        end

        it "stores attributes" do
          [
            :forma_de_pago,
            :observaciones,
            :delivery_method,
            :customer_address_id,
            :customer_billing_address_id
          ].each do |attribute|
            expect(
              customer_order.reload.send(attribute)
            ).to eq(checkout_attributes[attribute])
          end
        end
      end
    end

    describe "pickup" do
      let(:customer_billing_address) {
        create :customer_billing_address,
               customer_profile: user.customer_profile
      }
      let(:checkout_attributes) {
        {
          forma_de_pago: "efectivo",
          delivery_method: "pickup",
          customer_billing_address_id: customer_billing_address.id
        }
      }

      it { expect(subject.save).to be_truthy }
    end
  end
end
