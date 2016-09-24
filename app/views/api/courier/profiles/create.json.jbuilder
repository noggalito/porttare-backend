json.courier_profile do
  json.partial!(
    "api/couriers/courier_profile",
    courier_profile: @courier_profile
  )
end
