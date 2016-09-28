json.provider_dispatchers do
  json.array!(
    @provider_dispatchers,
    partial: "dispatcher",
    as: :provider_dispatcher
  )
end
