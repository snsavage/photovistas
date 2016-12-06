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
      redirect to "/settings/#{user.username}"
    else
      flash[:form_errors] = user.errors.full_messages
      erb :'/signups/new'
    end
  end

  get '/settings/?:username?' do |username|
    if logged_in? && username == current_user.username
      if unsplash_user
        all_likes = unsplash_user.likes
        @likes = all_likes.first(5).map do |photo|
          {id: photo.id, thumb: photo.urls.thumb}
        end
        @unsplash_username = unsplash_user.username

        @count_of_likes = all_likes.count

        @collections = Unsplash::User.current.collections.map do |collection|
          {
            title: collection.title,
            id: collection.id,
            count: collection.total_photos,
            photos: collection.photos.first(5).map do |photo|
              {id: photo.id, thumb: photo.urls.thumb}
            end
          }
        end
      end
      # @photos = []

      # if unsplash_user
      #   photos = []
      #   page = 1

      #   while [] != likes = unsplash_user.likes(page, 30)
      #     photos << likes.map do |photo|
      #       photo.urls.thumb
      #     end
      #     page += 1
      #   end

      #   @photos = photos.flatten
      # end

      erb :'users/show'
    else
      redirect to"/"
    end
  end
end

