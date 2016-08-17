json.provider_items do
  json.array!(
    @provider_items,
    partial: "item",
    as: :provider_item
  )
end
