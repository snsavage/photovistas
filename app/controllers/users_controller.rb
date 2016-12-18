require_relative 'application_controller'

class UsersController < ApplicationController
  get '/bookmark/default' do
    redirect to "/" if !logged_in?

    @photo = User.default.current_photo

    erb :'/users/bookmark', locals: {bookmark: true}
  end

  get '/bookmark/:username' do |username|
    redirect to "/" if !logged_in? || current_user.username != username

    if current_user.has_queue?
      @photo = current_user.current_photo
    else
      flash[:notice] = ["Your queue is empty.  Please add some photos."]
      redirect to "/settings/#{current_user.username}"
    end

    erb :'/users/bookmark', locals: {bookmark: true}
  end

  get '/signup' do
    redirect to "/" if logged_in?
    erb :'/signups/new'
  end

  post '/signup' do
    redirect to "/" if logged_in?

    credentials = filter_params(
      params[:credentials],
      %w(username email password password_confirmation)
    )

    user = User.create(credentials)

    if user.valid?
      session[:user_id] = user.id
      redirect to "/unsplash/auth" if params[:unsplash]
      redirect to "/settings/#{user.username}"
    else
      flash[:error] = user.errors.full_messages

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
      params[:credentials][:password] != "" &&
      !current_user.authenticate(params[:current])

      flash[:error] =
        ["Please provide your current password to change passwords."]

      halt erb(:'/users/edit')
    end

    credentials = filter_params(
      params[:credentials],
      %w(username email password password_confirmation time_zone)
    )

    current_user.update(credentials)
    if current_user.valid?
      redirect to "/settings/#{current_user.username}"
    else
      flash[:error] = current_user.errors.full_messages
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


