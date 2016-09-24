# == Schema Information
#
# Table name: courier_profiles
#
#  id                      :integer          not null, primary key
#  user_id                 :integer
#  nombres                 :string
#  ruc                     :string
#  telefono                :string
#  email                   :string
#  ubicacion               :integer
#  tipo_medio_movilizacion :integer
#  fecha_nacimiento        :date
#  tipo_licencia           :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

FactoryGirl.define do
  factory :courier_profile do
    user

    ruc              { Faker::Code.npi }
    email            { Faker::Internet.email }
    nombres          { Faker::Name.name }
    telefono         { Faker::PhoneNumber.phone_number }
    fecha_nacimiento { Faker::Date.birthday }
    ubicacion        {
      CourierProfile::UBICACIONES.sample
    }
    tipo_licencia    {
      CourierProfile::TIPOS_LICENCIA.sample
    }
    tipo_medio_movilizacion {
      CourierProfile::TIPOS_MEDIO_MOVILIZACION.sample
    }
  end
end
