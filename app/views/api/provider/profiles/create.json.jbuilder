json.provider_profile do
  json.partial!(
    "api/providers/provider_profile",
    provider_profile: @resource.provider_profile
  )
  json.partial!(
    "api/providers/private_provider_profile",
    provider_profile: @resource.provider_profile
  )
end
