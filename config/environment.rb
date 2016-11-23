ENV['RACK_ENV'] ||= "development"

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])

Dotenv.load

require_rel "../app/"

Unsplash.configure do |config|
  config.application_id = ENV['UNSPLASH_ID']
  config.application_secret = ENV['UNSPLASH_SECRET']
  config.application_redirect_uri = ENV['UNSPLASH_REDIRECT_URI']
end

