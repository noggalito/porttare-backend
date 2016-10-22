# == Schema Information
#
# Table name: provider_offices
#
#  id                  :integer          not null, primary key
#  provider_profile_id :integer          not null
#  enabled             :boolean          default(FALSE)
#  direccion           :string           not null
#  ciudad              :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  telefono            :string
#  hora_de_apertura    :time
#  hora_de_cierre      :time
#

require "porttare_backend/places"

FactoryGirl.define do
  factory :provider_office do
    provider_profile
    hora_de_apertura   "10:00 AM"
    hora_de_cierre     "19:00 PM"
    direccion { Faker::Address.street_address }
    ciudad    { PorttareBackend::Places.all.sample }
    telefono  { Faker::PhoneNumber.phone_number }

    trait :enabled do
      enabled true
    end
  end
end
