source "https://rubygems.org"

ruby '2.3.1'

gem 'puma'
gem 'sinatra'
gem 'require_all'
gem 'bcrypt'
gem 'pg'
gem 'activerecord', :require => 'active_record'
gem 'sinatra-activerecord', :require => 'sinatra/activerecord'
gem 'rake'
gem "rack-flash3", :require => "rack-flash"
# gem "sinatra-flash"
# gem 'unsplash', '~>1.4'
gem 'unsplash', git: "https://github.com/snsavage/unsplash_rb.git", branch: "savage"
gem 'activesupport', :require => 'active_support/core_ext/time'
gem 'rack-ssl'

# Assets
gem 'sprockets'
gem 'sprockets-helpers'
gem 'sinatra-asset-pipeline', '~> 1.0'
gem 'uglifier'
gem 'sass'
gem 'bourbon'
gem 'neat'
gem 'bitters'

group :production do
  gem 'newrelic_rpm'
  gem 'rack-google-analytics'
end

group :development do
  gem 'derailed'
end

group :development, :test do
  gem 'dotenv'
  gem 'pry'
end

group :test do
  gem 'rspec'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'launchy'
  gem 'rack-test'
  gem 'database_cleaner'
  gem 'factory_girl'
  gem 'fuubar'
  gem 'webmock'
  gem 'vcr'
  gem 'timecop'
  gem "simplecov"
  gem "codeclimate-test-reporter", "~> 1.0.0"
end

