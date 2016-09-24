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

require "porttare_backend/places"

class CourierProfile < ActiveRecord::Base
  UBICACIONES = PorttareBackend::Places.all

  TIPOS_LICENCIA = [
    "A",
    "A1",
    "B",
    "C1",
    "C",
    "D1",
    "D",
    "E1",
    "E",
    "F",
    "G"
  ].freeze

  TIPOS_MEDIO_MOVILIZACION = [
    "Motocicleta particular", # (A)
    "Motocicleta comercial",  # (A1)
    "Automóvil particular",   # (B)
    "Automóvil estatal",      # (C1)
    "Automóvil comercial",    # (C)
    "Bus escolar / turismo",  # (D1)
    "Bus pasajeros",          # (D)
    "Pesado",                 # (E)
    "Especiales"              # (E1)
  ].freeze

  begin :relationships
    belongs_to :user
  end

  begin :enumerables
    enum ubicacion: UBICACIONES
    enum tipo_licencia: TIPOS_LICENCIA
    enum tipo_medio_movilizacion: TIPOS_MEDIO_MOVILIZACION
  end

  begin :validations
    validates :ruc,
              :nombres,
              :email,
              :telefono,
              presence: true
    validates :ruc,
              :email,
              :telefono,
              uniqueness: true
    validates :ubicacion,
              inclusion: { in: UBICACIONES }
    validates :tipo_licencia,
              inclusion: { in: TIPOS_LICENCIA }
    validates :tipo_medio_movilizacion,
              inclusion: { in: TIPOS_MEDIO_MOVILIZACION }
  end
end
