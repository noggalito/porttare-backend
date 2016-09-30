json.extract!(
  provider_dispatcher,
  :id,
  :email,
  :provider_office_id
)
json.user do
  if provider_dispatcher.user
    json.partial!(
      "user",
      user: provider_dispatcher.user
    )
  end
end
