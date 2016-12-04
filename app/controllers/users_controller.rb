require_relative 'application_controller'

class UsersController < ApplicationController
  get '/settings' do
    if logged_in?
      @user = current_user
      @unsplash_user = unsplash_user


      photos = []
      page = 1

      while [] != likes = unsplash_user.likes(page, 30)
        photos << likes.map do |photo|
          photo.urls.thumb
        end
        page += 1
      end

      @photos = photos.flatten

      erb :'users/show'
    else
      redirect to"/"
    end
  end
end

