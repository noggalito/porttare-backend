# public provider profile

json.extract!(
  provider_profile,
  :id,
  :ruc,
  :razon_social,
  :nombre_establecimiento,
  :actividad_economica,
  :representante_legal,
  :telefono,
  :email,
  :website,
  :formas_de_pago,
  :logotipo,
  :facebook_handle,
  :twitter_handle,
  :instagram_handle,
  :youtube_handle
)

json.offices do
  json.array!(
    provider_profile.offices,
    partial: "api/providers/provider_office",
    as: :provider_office
  )
end
