source 'https://rubygems.org'

gem 'rails', '4.2.7.1'
gem 'pg', '~> 0.15'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'slim', '~> 3.0'
gem 'carrierwave', '~> 0.11'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 0.4.0'
end

group :api do
  gem 'apipie-rails'
  gem 'maruku'
end

gem 'omniauth', '~> 1.3'
gem 'devise_token_auth', '~> 0.1'
gem 'omniauth-facebook', '~> 3.0'
gem 'rack-cors', '~> 0.4', require: 'rack/cors'
gem 'pundit', '~> 1.1'
gem 'money-rails', '~> 1.6'
gem 'kaminari', '~> 0.17'
gem 'airbrake', '~> 4.3'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.4'
  gem 'factory_girl_rails', '~> 4.7'
  gem 'database_cleaner'
  gem 'faker', '~> 1.6'
  gem 'rspec_junit_formatter', '~> 0.2'
  gem 'capybara', '~> 2.8'
  gem 'bullet', '~> 5.4'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'letter_opener'
  gem 'annotate', '~> 2.7'
end

group :heroku do
  gem 'rails_12factor'
  gem 'cloudinary', '~> 1.2'
end
