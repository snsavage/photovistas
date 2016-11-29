require 'sinatra/base'

class ApplicationController < Sinatra::Base

  enable :sessions
  set :session_secret, "secret" if !production?
  use Rack::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    erb :index
  end
end

