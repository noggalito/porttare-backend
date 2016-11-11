class ProviderOfficePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(
        provider_profile_id: user.provider_profile.id
      )
    end
  end

  def create?
    is_provider?
  end

  def permitted_attributes
    [
      :ciudad,
      :hora_de_apertura,
      :hora_de_cierre,
      :telefono,
      :direccion
    ]
  end

  private

  def is_provider?
    user.provider_profile.present?
  end
end
