json.extract!(
  user,
  :id,
  :uid,
  :name,
  :info,
  :image,
  :email,
  :ciudad,
  :nickname,
  :provider,
  :custom_image_url,
  :agreed_tos
)
json.fecha_nacimiento(
  l(user.fecha_nacimiento, format: :api)
) if user.fecha_nacimiento.present?
