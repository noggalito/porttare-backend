class ProviderItemPolicy < ApplicationPolicy
  class ProviderScope < Scope
    def resolve
      scope.where(
        provider_profile_id: user.provider_profile.id
      )
    end
  end

  class PublicScope < Scope
    # TODO: define public scope
    # probably something like filter out
    # deleted ones ?
    # def resolve; scope.all; end
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

  def destroy?
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
      :observaciones,
      :cantidad,
      imagenes_attributes: [
        :id,
        :imagen,
        :_destroy
      ]
    ]
  end

  private

  def is_provider?
    user.provider_profile.present?
  end
end
