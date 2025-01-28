# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.1'
gem 'bootsnap', require: false
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.1.3', '>= 7.1.3.2'
gem 'tzinfo-data', platforms: %i[windows jruby]

gem 'redis', '~> 5.2'
gem 'sidekiq', '~> 7.2', '>= 7.2.4'
gem 'sidekiq-scheduler', '~> 5.0', '>= 5.0.3'

gem 'pry'
gem 'pry-remote'

gem 'guard'
gem 'guard-livereload', require: false

gem 'devise'
gem 'devise-api', github: 'nejdetkadir/devise-api', branch: 'main'

gem 'active_model_serializers', '~> 0.10.0'

group :development, :test do
  gem 'debug', platforms: %i[mri windows]
  gem 'rspec-rails', '~> 6.1.0'

  gem 'factory_bot_rails'

  gem 'rubocop', '~> 1.60', require: false
  gem 'rubocop-rails', '2.20.2'
end

group :test do
  gem 'simplecov', require: false
end
