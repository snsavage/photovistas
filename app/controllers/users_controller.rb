require_relative 'application_controller'

class UsersController < ApplicationController
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

