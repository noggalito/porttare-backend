json.provider do
  json.partial! "provider_profile",
                provider_profile: @provider
  json.products do
    json.array!(
      @provider.provider_items,
      partial: "api/provider/items/item",
      as: :provider_item
    )
  end
end
