# == Schema Information
#
# Table name: provider_offices
#
#  id                  :integer          not null, primary key
#  provider_profile_id :integer          not null
#  enabled             :boolean          default(FALSE)
#  direccion           :string           not null
#  ciudad              :string
#  horario             :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  telefono            :string
#

require "porttare_backend/places"

class ProviderOffice < ActiveRecord::Base
  belongs_to :provider_profile

  validates :direccion,
            :horario,
            :telefono,
            presence: true
  validates :ciudad,
            inclusion: { in: PorttareBackend::Places.all }
end
