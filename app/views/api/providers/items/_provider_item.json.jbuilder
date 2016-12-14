json.extract!(
  provider_item,
  :id,
  :titulo,
  :descripcion,
  :unidad_medida,
  :precio_cents,
  :volumen,
  :peso,
  :observaciones,
  :provider_item_category_id
)

json.imagenes do
  json.array!(
    provider_item.imagenes,
    partial: "api/providers/items/provider_item_image",
    as: :provider_item_image
  )
end
