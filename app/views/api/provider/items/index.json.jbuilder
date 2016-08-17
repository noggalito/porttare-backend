json.provider_items do
  json.array!(
    @provider_items,
    :id,
    :titulo,
    :descripcion,
    :unidad_medida,
    :precio_cents,
    :volumen,
    :peso,
    :imagen,
    :observaciones,
    :created_at,
    :updated_at
  )
end
