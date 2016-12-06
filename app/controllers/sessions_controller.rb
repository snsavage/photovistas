require_relative 'application_controller'

class SessionsController < ApplicationController
  get '/login' do
    if !logged_in?
      erb :'/sessions/login'
    else
      redirect to "/"
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect to "/login"
    else
      redirect to "/"
    end
  end

  post '/login' do
    redirect to "/" if logged_in?

    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to "/settings/#{user.username}"
    else
      flash[:login_errors] = "Please provide a valid username and password."
      erb :"/sessions/login"
    end
  end

end
