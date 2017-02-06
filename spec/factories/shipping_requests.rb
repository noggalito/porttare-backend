# == Schema Information
#
# Table name: shipping_requests
#
#  id                  :integer          not null, primary key
#  resource_id         :integer          not null
#  resource_type       :string           not null
#  kind                :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  status              :string           default("new"), not null
#  address_attributes  :json
#  courier_profile_id  :integer
#  reason              :string
#  place_id            :integer          not null
#  waypoints           :json
#  estimated_time_mins :integer
#  assigned_at         :datetime
#  ref_lat             :float            not null
#  ref_lon             :float            not null
#

FactoryGirl.define do
  factory :shipping_request do
    resource { build :provider_profile }
    kind     { ShippingRequest.kind.values.first }
    place {
      Place.first.presence || build(:place)
    }

    trait :for_customer_order_delivery do
      kind :customer_order_delivery
      resource { create :customer_order_delivery }
    end
  end
end
