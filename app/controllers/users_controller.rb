require_relative 'application_controller'

class UsersController < ApplicationController
  get '/signup' do
    if !logged_in?
      erb :'/users/new'
    else
      redirect to "/"
    end
  end

  get '/login' do
    if !logged_in?
      erb :'/users/login'
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
      redirect to "/users/#{user.id}"
    else
      flash[:login_errors] = "Please provide a valid username and password."
      erb :"/users/login"
    end
  end

  get '/users/:id' do
    @user = User.find_by(id: params[:id])

    if @user && logged_in? && @user.id == current_user.id
      erb :'users/show'
    else
      redirect to "/"
    end
  end

  post '/users' do
    redirect to "/" if logged_in?

    user = User.create(params)

    if user.valid?
      session[:user_id] = user.id
      redirect to "/users/#{user.id}"
    else
      flash[:form_errors] = user.errors.full_messages
      erb :'/users/new'
    end
  end
end
