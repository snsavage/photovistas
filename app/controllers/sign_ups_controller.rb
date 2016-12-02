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
    redirect to '/' if !logged_in?

    requested_scopes = ["public"]
    auth_url = Unsplash::Client.connection.authorization_url(requested_scopes)
    redirect auth_url
  end

  get '/unsplash/callback' do
    redirect to '/' if !logged_in?

    if params[:code]
      # begin
        unsplash_authorize(params[:code])
        unsplash_save_token
      # rescue Exception => e
        flash[:notice] = "Unable to access Unsplash account.  Please try again."
        # logger.info "*** Unsplash Error: #{e.message} ***"
      # end
    end

    redirect to "/settings"
  end

  get '/unsplash/deauth' do
    redirect to '/' if !logged_in?

    current_user.update(unsplash_token: nil,
                        unsplash_username: nil)

    redirect to "/settings"
  end
end

