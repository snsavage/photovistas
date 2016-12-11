ENV['RACK_ENV'] ||= "development"

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])

Dotenv.load if ENV['RACK_ENV'] != "production"

require_rel "../app/"
require_rel "../lib/"

Unsplash.configure do |config|
  config.application_id = ENV['UNSPLASH_ID']
  config.application_secret = ENV['UNSPLASH_SECRET']
  config.application_redirect_uri = ENV['UNSPLASH_REDIRECT_URI']
  if ENV['RACK_ENV'] != "production"
    config.application_redirect_uri = "http://127.0.0.1:9292/unsplash/callback"
  end
end



