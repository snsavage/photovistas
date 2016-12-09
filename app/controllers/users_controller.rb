require_relative 'application_controller'

class UsersController < ApplicationController
  get '/bookmark/:username' do
    @url = current_user.photo_queues.sample.photo.full_url
    erb :'/users/bookmark'
  end

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

        @count_of_likes = unsplash_user.total_likes

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

      erb :'users/show'
    else
      redirect to"/"
    end
  end

  get '/settings/:username/edit' do |username|
    if logged_in? && current_user.username == username
      @user_data = {username: current_user.username, email: current_user.email}
      erb :'/users/edit'
    else
      redirect to "/"
    end
  end

  patch '/settings/:username' do |username|
    redirect to "/" if !logged_in? || current_user.username != username

    @user_data = {
      username: params[:credentials][:username],
      email: params[:credentials][:email]
    }

    if params[:credentials][:password] && 
      !current_user.authenticate(params[:current])

      flash[:form_errors] =
        ["Please provide your current password to change passwords."]

      halt erb(:'/users/edit')
    end

    current_user.update(params[:credentials])
    if current_user.valid?
      redirect to "/settings/#{current_user.username}"
    else
      flash[:form_errors] = current_user.errors.full_messages
      erb :'/users/edit'
    end
  end
end

