json.provider_profile do
  json.partial!(
    "api/providers/provider_profile",
    provider_profile: @provider_profile
  )
  json.partial!(
    "api/providers/private_provider_profile",
    provider_profile: @provider_profile
  )
end
