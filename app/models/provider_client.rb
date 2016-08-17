# == Schema Information
#
# Table name: provider_clients
#
#  id                  :integer          not null, primary key
#  provider_profile_id :integer
#  notas               :text
#  ruc                 :string
#  nombres             :string
#  direccion           :string
#  telefono            :string
#  email               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class ProviderClient < ActiveRecord::Base
  #relationships
  belongs_to :provider_profile

  #validations
  validates :provider_profile_id,
            :ruc,
            :nombres,
            :direccion,
            :telefono,
            :email,
            presence: true
end
