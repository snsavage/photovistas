require_relative 'application_controller'

class SignUpsController < ApplicationController
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

  get '/unsplash/auth' do
    requested_scopes = ["public"]
    auth_url = Unsplash::Client.connection.authorization_url(requested_scopes)
    redirect auth_url
  end

  get '/unsplash/callback' do
    begin
      if !session[:unsplash]
        Unsplash::Client.connection.authorize!(params["code"])
        session[:unsplash] = Unsplash::Client.connection.extract_token
        erb "Session token set to #{session[:unsplash][:access_token]}"
      else
        Unsplash::Client.connection.create_and_assign_token(session[:unsplash])
        erb "Current User is #{Unsplash::User.current[:username]}"
      end

    rescue
      flash[:notice] = "Unable to link your Unsplash account.  Please try again."
      redirect to "/settings"
    end
  end
end

