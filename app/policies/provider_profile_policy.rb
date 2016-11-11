class ProviderProfilePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(
        user_id: user.id
      )
    end
  end

  def create?
    # if the user doesn't have a provider profile already
    user.provider_profile.nil?
  end

  def permitted_attributes
    # non-allowed attributes
    # tipo_contribuyente
    # fecha_inicio_actividad
    [
      :ruc,
      :razon_social,
      :actividad_economica,
      :representante_legal,
      :telefono,
      :email,
      :banco_nombre,
      :banco_numero_cuenta,
      :banco_tipo_cuenta,
      :website,
      :facebook_handle,
      :twitter_handle,
      :instagram_handle,
      :youtube_handle,
      :nombre_establecimiento,
      formas_de_pago: [],
      offices_attributes: offices_attributes
    ]
  end

  private

  def offices_attributes
    ProviderOfficePolicy.new(user,record).permitted_attributes
  end
end
