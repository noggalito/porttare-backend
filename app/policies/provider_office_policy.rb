class ProviderOfficePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(
        provider_profile_id: user.provider_profile.id
      )
    end
  end
  
  def show?
    is_provider?
  end

  def index?
    is_provider?
  end

  def create?
    is_provider?
  end

  def update?
    is_provider?
  end

  def permitted_attributes
    [
      :ciudad,
      :telefono,
      :direccion,
      :hora_de_apertura,
      :hora_de_cierre,
      :final_de_labores,
      :inicio_de_labores
    ]
  end

  private

  def is_provider?
    user.provider_profile.present?
  end
end
