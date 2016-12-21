# == Schema Information
#
# Table name: customer_orders
#
#  id                                  :integer          not null, primary key
#  status                              :integer          default(0), not null
#  subtotal_items_cents                :integer          default(0), not null
#  subtotal_items_currency             :string           default("USD"), not null
#  customer_profile_id                 :integer          not null
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  deliver_at                          :datetime
#  delivery_method                     :integer
#  forma_de_pago                       :integer
#  observaciones                       :text
#  customer_address_attributes         :text
#  customer_billing_address_attributes :text
#  customer_address_id                 :integer
#  customer_billing_address_id         :integer
#  submitted_at                        :datetime
#

require 'rails_helper'

RSpec.describe CustomerOrder,
               type: :model do
  describe "factory" do
    subject { build :customer_order }
    it { is_expected.to be_valid }
    it "default status" do
      is_expected.to be_in_progress
    end
  end

  describe "#in_progress scope" do
    let(:customer_order_in_progress) {
      create :customer_order, status: :in_progress
    }

    let(:customer_order_submitted) {
      create :customer_order, status: :submitted
    }

    before do
      customer_order_submitted
      customer_order_in_progress
    end

    subject { described_class.in_progress }

    it {
      is_expected.to include(customer_order_in_progress)
      is_expected.to_not include(customer_order_submitted)
    }
  end

  describe "#submit - upon submission" do
    let(:customer_order) {
      create :customer_order,
             :with_customer_billing_address
    }
    let(:customer_order_item) {
      create :customer_order_item,
             customer_order: customer_order
    }

    describe "caches #subtotal_items" do
      before do
        customer_order_item
        customer_order.submit!
      end

      it {
        expect(
          customer_order[:subtotal_items_cents]
        ).to be_present

        expect(
          customer_order.subtotal_items
        ).to eq(customer_order_item.subtotal)
      }
    end

    describe "caches order_items #provider_item_precio" do
      let(:provider_item) {
        customer_order_item.provider_item
      }
      let(:old_price) {
        provider_item.precio
      }

      before do
        old_price
        customer_order.submit!
        # update price
        provider_item.update!(
          precio: provider_item.precio + Money.from_amount(1.99, "USD")
        )
      end

      it {
        expect(
          customer_order_item.reload[:provider_item_precio_cents]
        ).to be_present

        expect(
          customer_order_item.provider_item_precio
        ).to eq(old_price)
      }
    end
  end

  describe "validates own address" do
    subject { build :customer_order }
    let(:customer_address) { create :customer_address }
    before {
      subject.customer_address = customer_address
    }
    it {
      is_expected.to_not be_valid
      expect(subject.errors).to have_key(:customer_address_id)
    }
  end

  describe "deliver_at must be in future" do
    subject { build :customer_order }
    it {
      subject.deliver_at = 1.week.ago
      is_expected.to_not be_valid
      expect(
        subject.errors
      ).to have_key(:deliver_at)
    }
    it {
      subject.deliver_at = 1.week.from_now
      is_expected.to be_valid
    }
  end
end
