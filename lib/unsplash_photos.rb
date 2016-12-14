class UnsplashPhotos
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
  def set_photo_attributes(photo)
    {
      unsplash_id: photo.id,
      width: photo.width,
      height: photo.height,
      photographer_name: photo.user.name,
      photographer_link: photo.user.links.html,
      raw_url: photo.urls.raw,
      full_url: photo.urls.full,
      regular_url: photo.urls.regular,
      small_url: photo.urls.small,
      thumb_url: photo.urls.thumb,
      link: photo.links.html
    }
  end

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
end

