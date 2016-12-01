source 'https://rubygems.org'

gem 'tzinfo-data', platforms: [:x64_mingw, :mingw, :mswin]

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
gem 'enumerize', '~> 2.0'
gem 'bootstrap-sass', '~> 3.3.7'
gem 'draper', '~> 2.1'
gem 'paper_trail', '~> 5.2'
gem 'postgres_ext', '~> 3.0'
gem 'dotenv-rails', '~> 2.1'

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
  gem 'simplecov', '~> 0.12'
end

group :deployment do
  gem 'capistrano', '~> 3.6'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano-bundler', '~> 1.2'
  gem 'capistrano-rails', '~> 1.2'
  gem 'capistrano-passenger', '~> 0.2'
  gem 'slackistrano', '~> 3.1', require: false
end

group :test do
  gem 'codeclimate-test-reporter', '~> 0.6', require: nil
end

group :heroku do
  gem 'rails_12factor'
  gem 'cloudinary', '~> 1.2'
end
