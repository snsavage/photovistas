require 'sinatra/base'
require 'sinatra/asset_pipeline'

class ApplicationController < Sinatra::Base
  set :assets_paths, %w(./../assets/stylesheets ./../assets/images)
  set :assets_precompile, %w(app.js app.css bookmark.css clear.css *.png *.jpg *.svg *.eot *.ttf *.woff *.woff2)
  register Sinatra::AssetPipeline

  helpers SessionHelpers
  helpers UnsplashHelpers
  helpers Sprockets::Helpers

  enable :sessions
  set :session_secret, ENV['SESSION_SECRET']
  use Rack::Flash, sweep: true

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  configure :production, :development do
    enable :logging
  end

  get '/' do
    erb :index, locals: {clear: true}
  end

  get '/contact' do
    erb :contact
  end

  get '/help' do
    erb :help
  end
end

