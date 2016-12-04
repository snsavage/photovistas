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
end

