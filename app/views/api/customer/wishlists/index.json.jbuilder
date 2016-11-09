json.customer_wishlists do
  json.array!(
    @customer_wishlists,
    partial: "customer_wishlist",
    as: :customer_wishlist
  )
end

json.provider_profiles do
  json.array!(
    @provider_profiles,
    partial: "provider_profile",
    as: :provider_profile
  )
end