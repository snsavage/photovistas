require 'sinatra/base'

class ApplicationController < Sinatra::Base

  helpers SessionHelpers
  helpers UnsplashHelpers

  enable :sessions
  set :session_secret, "secret" if !production?
  use Rack::Flash, sweep: true

  # assets_env = Sprockets::Environment.new
  # assets_env.append_path "app/assets/stylesheets"
  # assets_env.append_path "app/assets/javascripts"

  # assets_env.js_compressor  = :uglify
  # assets_env.css_compressor = :sass

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  configure :production, :development do
    enable :logging
  end

  get '/' do
    erb :index
  end
end

