require_relative 'application_controller'

class UnsplashController < ApplicationController
  get '/unsplash/auth' do
    redirect to '/' if !logged_in?

    requested_scopes = ["public"]
    auth_url = Unsplash::Client.connection.authorization_url(requested_scopes)
    redirect auth_url
  end

  get '/unsplash/callback' do
    redirect to '/' if !logged_in?

    if params[:code]
      begin
        unsplash_authorize(params[:code])
        unsplash_save_token
      rescue Exception => e
        flash[:error] = ["Unable to access Unsplash account.  Please try again."]
        logger.info "*** Unsplash Error: #{e.message} ***"
      end
    end

    redirect to "/settings/#{current_user.username}"
  end

  get '/unsplash/unlink' do
    redirect to '/' if !logged_in?

    current_user.update(unsplash_token: nil,
                        unsplash_username: nil)

    redirect to "/settings/#{current_user.username}"
  end
end
