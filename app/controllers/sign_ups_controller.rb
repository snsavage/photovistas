require_relative 'application_controller'

class SignUpsController < ApplicationController
  get '/signup' do
    if !logged_in?
      erb :'/signups/new'
    else
      redirect to "/"
    end
  end

  post '/signup' do
    redirect to "/" if logged_in?

    user = User.create(params)

    if user.valid?
      session[:user_id] = user.id
      session[:step] = "1"
      redirect to "/signup/unsplash"
    else
      flash[:form_errors] = user.errors.full_messages
      erb :'/signups/new'
    end
  end

  get '/signup/unsplash' do
    redirect to "/" if !logged_in?

    if session[:step] == "1"
      erb :"/signups/unsplash"
    else
      redirect to "/users/#{current_user.id}"
    end
  end

  post '/signup/unsplash' do
    if logged_in? && session[:step] == "1" && params.has_key?("add_username")
      current_user.update(unsplash_username: params[:unsplash_username])
      current_user.save
      session[:step] << "2"
      redirect to :"/signup/photos"
    else
      redirect to "/users/#{current_user.id}" if params.has_key?("skip")
      redirect to "/"
    end
  end
end

