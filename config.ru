require_relative "./config/environment"

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path './app/assets/javascripts'
  environment.append_path './app/assets/stylesheets'
  run environment
end

use Rack::MethodOverride
use QueueController
use SessionsController
use UsersController
use UnsplashController
run ApplicationController

