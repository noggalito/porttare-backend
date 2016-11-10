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

class ProviderOffice < ActiveRecord::Base
  belongs_to :provider_profile
  has_many :provider_dispatchers,
           dependent: :destroy

  validates :telefono,
            :direccion,
            :hora_de_cierre,
            :hora_de_apertura,
            presence: true
  validates :ciudad,
            inclusion: { in: PorttareBackend::Places.all }

  scope :enabled, -> { where(enabled: true) }
end
