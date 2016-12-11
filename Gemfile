source "https://rubygems.org"

ruby '2.3.1'

gem 'sinatra'
gem 'require_all'
gem 'bcrypt'
gem 'pg'
gem 'activerecord', :require => 'active_record'
gem 'sinatra-activerecord', :require => 'sinatra/activerecord'
gem 'rake'
gem "rack-flash3", :require => "rack-flash"
# gem 'unsplash', '~>1.4'
gem 'unsplash', git: "https://github.com/snsavage/unsplash_rb.git", branch: "savage"

# Assets
gem 'sprockets'
gem 'uglifier'
gem 'sass'
gem 'bourbon'
gem 'neat'
gem 'bitters'

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
end

