json.extract!(
  provider_office,
  :id,
  :direccion,
  :ciudad,
  :telefono,
  :inicio_de_labores,
  :final_de_labores
)

json.hora_de_apertura(
  l(provider_office.hora_de_apertura, format: :office_schedule)
) if provider_office.hora_de_apertura.present?
json.hora_de_cierre(
  l(provider_office.hora_de_cierre, format: :office_schedule)
) if provider_office.hora_de_cierre.present?
