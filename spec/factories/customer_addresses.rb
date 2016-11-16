# == Schema Information
#
# Table name: customer_addresses
#
#  id                  :integer          not null, primary key
#  ciudad              :string
#  parroquia           :string
#  barrio              :string
#  direccion_uno       :string
#  direccion_dos       :string
#  codigo_postal       :string
#  referencia          :text
#  numero_convencional :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  customer_profile_id :integer          not null
#  nombre              :string
#

FactoryGirl.define do
  factory :customer_address do
    customer_profile

    nombre              { Faker::Address.name }
    ciudad              { Faker::Address.city }
    parroquia           { Faker::Address.state }
    barrio              { Faker::Address.city_prefix }
    direccion_uno       { Faker::Address.street_address }
    direccion_dos       { Faker::Address.secondary_address }
    codigo_postal       { Faker::Address.postcode }
    referencia          { Faker::Hipster.paragraphs.join "\n" }
    numero_convencional { Faker::PhoneNumber.phone_number }
  end
end
