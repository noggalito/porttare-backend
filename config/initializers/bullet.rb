if Rails.env.development? || Rails.env.test?
  Bullet.enable = true
  Bullet.rails_logger = true
  Bullet.bullet_logger = true
end

if Rails.env.test?
  Bullet.raise = true
end
