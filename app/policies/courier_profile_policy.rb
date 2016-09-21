class CourierProfilePolicy < ApplicationPolicy
  def create?
    # if the user doesn't have a courier profile already
    user.courier_profile.nil?
  end

  def permitted_attributes
    [
      :ruc,
      :email,
      :nombres,
      :telefono,
      :ubicacion,
      :tipo_licencia,
      :fecha_nacimiento,
      :tipo_medio_movilizacion
    ]
  end
end
