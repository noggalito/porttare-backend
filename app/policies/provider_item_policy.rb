class ProviderItemPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(
        provider_profile_id: user.provider_profile.id
      )
    end
  end

  def index?
    is_provider?
  end

  def create?
    is_provider?
  end

  def permitted_attributes
    [
      :titulo,
      :descripcion,
      :unidad_medida,
      :precio,
      :volumen,
      :peso,
      :imagen,
      :observaciones
    ]
  end

  private

  def is_provider?
    user.provider_profile.present?
  end
end
