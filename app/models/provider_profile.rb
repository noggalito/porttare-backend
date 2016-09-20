# == Schema Information
#
# Table name: provider_profiles
#
#  id                     :integer          not null, primary key
#  user_id                :integer
#  ruc                    :string
#  razon_social           :string
#  actividad_economica    :string
#  tipo_contribuyente     :string
#  representante_legal    :string
#  telefono               :string
#  email                  :string
#  fecha_inicio_actividad :date
#  banco_nombre           :string
#  banco_numero_cuenta    :string
#  banco_identificacion   :string
#  website                :string
#  facebook_handle        :string
#  twitter_handle         :string
#  instagram_handle       :string
#  youtube_handle         :string
#  mejor_articulo         :text
#  formas_de_pago         :text             default([]), is an Array
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider_category_id   :integer
#  nombre_establecimiento :string           not null
#

class ProviderProfile < ActiveRecord::Base
  FORMAS_DE_PAGO = [
    "efectivo",
    "tarjeta_credito"
  ].freeze

  begin :relationships
    belongs_to :user
    belongs_to :provider_category
    has_many :provider_items
    has_many :provider_clients
    has_many :offices,
             class_name: 'ProviderOffice',
             dependent: :destroy # as it's nested

    accepts_nested_attributes_for(
      :offices,
      reject_if: proc { |attrs| attrs['direccion'].blank? }
    )
  end

  begin :validations
    validates :ruc,
              :email,
              :telefono,
              :banco_nombre,
              :razon_social,
              :actividad_economica,
              :banco_numero_cuenta,
              :banco_identificacion,
              :nombre_establecimiento,
              presence: true
    validates :ruc, uniqueness: true
    validate :validate_formas_de_pago
  end

  begin :callbacks
    before_create :auto_assign_category!
  end

  private

  def validate_formas_de_pago
    all_valid = formas_de_pago.all? do |forma_de_pago|
      FORMAS_DE_PAGO.include?(forma_de_pago)
    end
    errors.add(:formas_de_pago, :invalid) unless all_valid
  end

  def auto_assign_category!
    # TODO
    # remove me once we can assign
    # provider categories
    self.provider_category = ProviderCategory.all.sample
  end
end
