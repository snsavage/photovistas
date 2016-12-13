require 'sinatra/base'

class ApplicationController < Sinatra::Base

  helpers SessionHelpers
  helpers UnsplashHelpers

  enable :sessions
  set :session_secret, "secret" if !production?
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
end

