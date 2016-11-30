# == Schema Information
#
# Table name: provider_items
#
#  id                  :integer          not null, primary key
#  provider_profile_id :integer
#  titulo              :string           not null
#  descripcion         :text
#  unidad_medida       :integer
#  precio_cents        :integer          default(0), not null
#  precio_currency     :string           default("USD"), not null
#  volumen             :string
#  peso                :string
#  observaciones       :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  deleted_at          :datetime
#  cantidad            :integer          default(0)
#

class ProviderItem < ActiveRecord::Base
  include SoftDestroyable

  UNIDADES_MEDIDA = [
    "volumen",
    "unidades",
    "peso",
    "longitud"
  ].freeze

  enum unidad_medida: UNIDADES_MEDIDA

  monetize :precio_cents,
           numericality: false

  begin :validations
    validates :titulo,
              :cantidad,
              presence: true
    validates :precio,
              :cantidad,
              numericality: { greater_than: 0 }
    validates :unidad_medida,
              inclusion: { in: UNIDADES_MEDIDA }
  end

  begin :relationships
    belongs_to :provider_profile
    has_many :imagenes,
             class_name: 'ProviderItemImage',
             dependent: :destroy

    accepts_nested_attributes_for(
      :imagenes,
      allow_destroy: true,
      reject_if: proc { |attrs| attrs['imagen'].blank? }
    )
  end
end
