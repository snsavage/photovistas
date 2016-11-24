require 'sinatra/base'

class Application < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    unsplash = Unsplash::User.find("snsavage")
    User.create(username: unsplash.username)

    @user = User.find_by(username: unsplash.username)
    erb :index
  end
end


