require_relative 'application_controller'

class QueueController < ApplicationController
  post '/queue/:username' do |username|
    redirect to "/" if !logged_in? || current_user.username != username

    if unsplash_user
      if params[:collections] == "liked"
        photos = UnsplashPhotos.new(unsplash_user: unsplash_user).liked
      else
        photos = UnsplashPhotos.new(
          collection_id: params[:collections]
        ).collection
      end

      current_user.add_photos_to_queue(photos)
      flash[:notice] = ["Your Queue has been updated."]
    end

    redirect to "/settings/#{current_user.username}"
  end

  get '/queue/:username/edit' do |username|
    redirect to "/" if !logged_in? || current_user.username != username

    @queue = PhotoQueue.includes(:photo).where(user_id: current_user.id)
    erb :'/queues/edit'
  end

  patch '/queue/:username' do |username|
    redirect to "/" if !logged_in? || current_user.username != username

    if params[:queue]
      begin
        queues = current_user.photo_queues.find(params[:queue])
        current_user.photo_queues.destroy(queues)
      rescue

      end
      flash[:notice] = ["Your Queue has been updated."]
    end

    redirect to "/settings/#{current_user.username}"
  end

  delete '/queue/:username' do |username|
    redirect to "/" if !logged_in? || current_user.username != username

    current_user.photo_queues.clear
    flash[:notice] = ["All photos have been removed from your Queue."]

    redirect to "/settings/#{current_user.username}"
  end
end

