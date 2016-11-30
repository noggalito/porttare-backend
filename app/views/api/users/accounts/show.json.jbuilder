json.user do
  json.extract!(
    @api_resource,
    :id,
    :name,
    :email,
    :ciudad,
    :fecha_nacimiento,
    :custom_image_url
  )
  json.fecha_nacimiento(
    l(@api_resource.fecha_nacimiento, format: :api)
  ) if @api_resource.fecha_nacimiento.present?
end
