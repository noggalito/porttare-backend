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
#

class ProviderItem < ActiveRecord::Base
  UNIDADES_MEDIDA = [
    "volumen",
    "unidades",
    "peso",
    "longitud"
  ].freeze

  enum unidad_medida: UNIDADES_MEDIDA

  monetize :precio_cents,
           numericality: false

  begin :scopes
    default_scope { where(deleted_at: nil) }
  end

  begin :validations
    validates :titulo,
              presence: true
    validates :precio,
              numericality: { greater_than: 0 }
    validates :unidad_medida,
              inclusion: { in: UNIDADES_MEDIDA }
  end

  begin :relationships
    belongs_to :provider_profile
    has_many :imagenes,
             class_name: 'ProviderItemImage'

    accepts_nested_attributes_for(
      :imagenes,
      allow_destroy: true,
      reject_if: proc { |attrs| attrs['imagen'].blank? }
    )
  end

  begin :methods
    # performs a soft-delete
    def destroy
      update_attribute(:deleted_at, Time.now)
    end
  end
end
