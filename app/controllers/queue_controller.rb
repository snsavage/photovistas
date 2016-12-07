require_relative 'application_controller'

class QueueController < ApplicationController
  post '/queue/:username' do |username|
    if unsplash_user
      if params[:collections] == "liked"
        photos = UnsplashApi.new(unsplash_user: unsplash_user).liked
      else
        photos = UnsplashApi.new(collection_id: params[:collections]).collection
      end

      current_user.add_photos_to_queue(photos)
      flash[:notice] = "Your Queue has been updated."
    end

    redirect to "/settings/#{current_user.username}"
  end

end

class UnsplashApi
  attr_accessor :user
  def initialize(unsplash_user: nil, collection_id: nil)
    @user = unsplash_user
    @liked = nil
    @collection_id = collection_id
    @collection = nil
  end

  def liked
    @liked ||= get_photos(:unsplash_likes) if @user
  end

  def collection
    @collection ||= get_photos(:unsplash_collection) if @collection_id
  end

  private
  # def get_liked
  #   photos = []
  #   page = 1

  #   while [] != likes = unsplash_likes(page)
  #     photos << likes.map do |photo|
  #       set_photo_attributes(photo)
  #     end
  #     page += 1
  #   end

  #   photos.flatten
  # end

  # def get_collection
  #   photos = []
  #   page = 1

  #   while [] != collection_page = unsplash_collection(page)
  #     photos << collection_page.map do |photo|
  #       set_photo_attributes(photo)
  #     end
  #     page += 1
  #   end

  #   photos.flatten
  # end

  def get_photos(method)
    photos = []
    page = 1

    while [] != page_of_photos = self.send(method, page)
      photos << page_of_photos.map do |photo|
        set_photo_attributes(photo)
      end
      page += 1
    end

    photos.flatten
  end

  def unsplash_likes(page)
    begin
      @user.likes(page, 30)
    rescue
      []
    end
  end

  def unsplash_collection(page)
    begin
      Unsplash::Collection.find(@collection_id).photos(page, 30)
    rescue
      []
    end
  end

  def set_photo_attributes(photo)
    {unsplash_id: photo.id,
     thumb_url: photo.urls.thumb}
  end
end

