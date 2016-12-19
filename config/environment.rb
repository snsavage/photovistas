ENV['RACK_ENV'] ||= "development"

require 'bundler/setup'
Bundler.require(:default, ENV['RACK_ENV'])

Dotenv.load if ENV['RACK_ENV'] != "production"

require_rel "../app/"
require_rel "../lib/"

GC::Profiler.enable

Unsplash.configure do |config|
  config.application_id = ENV['UNSPLASH_ID']
  config.application_secret = ENV['UNSPLASH_SECRET']
  config.application_redirect_uri = ENV['UNSPLASH_REDIRECT_URI']
end



