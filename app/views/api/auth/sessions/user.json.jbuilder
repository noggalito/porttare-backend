if @success.present?
  json.success @success
end

json.data do
  json.type @resource.class.name.parameterize

  json.extract!(
    @resource,
    :id,
    :provider,
    :uid,
    :name,
    :nickname,
    :image,
    :email,
    :info,
    :credentials
  )

  if @resource.provider_profile.present?
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
  end

  if @resource.courier_profile.present?
    json.courier_profile do
      json.partial!(
        "api/couriers/courier_profile",
        courier_profile: @resource.courier_profile
      )
    end
  end
end
