require_relative 'application_controller'

class UsersController < ApplicationController
  get '/bookmark/:username' do
    @url = current_user.photo_queues.sample.photo.full_url
    erb :'/users/bookmark', locals: {bookmark: true}
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

  get '/settings/?:username?' do |username|
    if logged_in? && username == current_user.username
      @total_photos = current_user.photo_queues.size
      @queue_sample = current_user.photos.sample(5)

      if unsplash_user
        @unsplash_data = UnsplashSettings.new(unsplash_user).refresh
      end

      erb :'users/show'
    else
      redirect to"/"
    end
  end
end


