require_relative 'application_controller'

class QueueController < ApplicationController
  post '/queue/:username' do |username|
    if unsplash_user
      if params[:collections] == "liked"
        photos = UnsplashPhotos.new(unsplash_user: unsplash_user).liked
      else
        photos = UnsplashPhotos.new(
          collection_id: params[:collections]
        ).collection
      end

      current_user.add_photos_to_queue(photos)
      flash[:notice] = "Your Queue has been updated."
    end

    redirect to "/settings/#{current_user.username}"
  end
end

