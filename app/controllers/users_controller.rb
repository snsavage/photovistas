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
end

