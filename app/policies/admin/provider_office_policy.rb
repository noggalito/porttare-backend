module Admin
  class ProviderOfficePolicy < BasePolicy
    def permitted_attributes
      [
        :id,
        :ciudad,
        :telefono,
        :direccion,
        :hora_de_apertura,
        :hora_de_cierre,
        :final_de_labores,
        :inicio_de_labores,
        :enabled
      ]
    end
  end
end
