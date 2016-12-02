require_relative 'application_controller'

class UsersController < ApplicationController
  get '/users/:id' do
    @user = User.find_by(id: params[:id])

    if @user && logged_in? && @user.id == current_user.id
      erb :'users/show'
    else
      redirect to "/"
    end
  end

  get '/settings' do
    if logged_in?
      @user = current_user
      @unsplash_user = unsplash_user
      erb :'users/show'
    else
      redirect to"/"
    end
  end
end

