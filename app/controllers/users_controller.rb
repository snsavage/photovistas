require_relative 'application_controller'

class UsersController < ApplicationController

  get '/signup' do
    erb :'/users/new'
  end

  get '/users/:id' do
    @user = User.find(params[:id])
    erb :'users/show'
  end

  post '/users' do
    user = User.create(params)
    if user.errors.any?
      flash[:form_errors] = user.errors.full_messages
      erb :'/users/new'
    else
      redirect to "/users/#{user.id}"
    end
  end
end
