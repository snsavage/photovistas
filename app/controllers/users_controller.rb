require_relative 'application_controller'

class UsersController < ApplicationController
  get '/signup' do
    redirect to "/" if logged_in?
    erb :'/signups/new'
  end

  post '/signup' do
    redirect to "/" if logged_in?

    user = User.create(params[:credentials])
    if user.valid?
      session[:user_id] = user.id
      redirect to "/unsplash/auth" if params[:unsplash]
      redirect to "/settings"
    else
      flash[:form_errors] = user.errors.full_messages
      erb :'/signups/new'
    end
  end

  get '/settings' do
    if logged_in?
      @user = current_user
      @unsplash_user = unsplash_user
      @photos = []

      if unsplash_user
        photos = []
        page = 1

        while [] != likes = unsplash_user.likes(page, 30)
          photos << likes.map do |photo|
            photo.urls.thumb
          end
          page += 1
        end

        @photos = photos.flatten
      end

      erb :'users/show'
    else
      redirect to"/"
    end
  end
end

