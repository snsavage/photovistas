require 'sinatra/base'

class Application < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    @user = Unsplash::User.find("snsavage")
    erb :index
  end
end

