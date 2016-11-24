if User.where.overlap(privileges: [:admin]).count == 0
  puts "creating default admin:"
  attributes = {
    email: "moviggoAdm@moviggo.com",
    password: "mov12345",
    password_confirmation: "mov12345",
    nickname: "moviggo",
    name: "moviggo",
    privileges: ["admin"]
  }
  puts attributes
  User.create!(attributes)
end

[
  "Agua bidón/Gas",
  "Alimentos no preparados",
  "Alimentos preparados",
  "Bebidas alcohólicas",
  "Encomiendas",
  "Medicinas",
  "Panadería y pastelería",
  "Floristería",
  "Boletería"
].each do |category_name|
  ProviderCategory.where(
    titulo: category_name
  ).first_or_create
end
