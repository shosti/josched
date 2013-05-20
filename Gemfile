source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '3.2.13'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '3.2.3'
  gem 'coffee-rails', '3.2.1'
  gem 'uglifier', '1.0.3'
end

group :development, :test do
  gem 'commands'
  gem 'debugger', github: 'cldwalker/debugger'
end

group :test do
  gem 'webmock', '1.11.0'
  gem 'rspec-rails', '2.13.1'
  gem 'guard-rspec', '2.6.0'
  gem 'factory_girl_rails', '4.2.1'
  gem 'database_cleaner', '0.9.1'
  gem 'capybara', '2.1.0'
  gem 'simplecov', '0.8.0.pre', require: false
  gem 'turnip', '1.1.0'
end

group :production do
  gem 'unicorn', '4.6.2'
end

gem 'pg', '0.15.1'
gem 'jquery-rails', '2.2.1'
gem 'bootstrap-sass', '2.3.1.0'
gem 'haml-rails', '0.4'
gem 'clearance', '1.0.0.rc7'
gem 'chronic', '0.9.1'
gem 'newrelic_rpm', '3.6.2.96'
gem 'json', '1.8.0'
gem 'figaro', '0.6.4'
