class UnsplashSettings
  PhotoData = Struct.new(:id, :thumb_url)
  CollectionData = Struct.new(:id, :title, :count, :photos)

  attr_reader :user, :api_count

  def initialize(unsplash_user = nil)
    @unsplash_user = unsplash_user
    @api_count = 0
    @error = false
  end

  def user
    begin
      raise if unavailable?
      @user ||= @unsplash_user.current
    rescue
      @error = true
      nil
    end
  end

  def available?
    !@error
  end

  def unavailable?
    @error
  end

  def refresh
    likes
    collections

    self
  end

  def likes
    @likes ||= get_likes if user
  end

  def collections
    @collections ||= get_collections if user
  end

  def likes_count
    @likes_count ||= user_api_call(:total_likes) if user
  end

  private
  def user_api_call(endpoint)
    begin
      raise if unavailable?
      @api_count += 1
      user.send(endpoint)
    rescue
      @error = true
      []
    end
  end

  def collection_api_call(collection, endpoint)
    begin
      raise if unavailable?
      @api_count += 1
      collection.send(endpoint)
    rescue
      @error = true
      []
    end
  end

  def get_likes
    user_api_call(:likes).map do |photo|
      PhotoData.new(photo.id, photo.urls.thumb)
    end
  end

  def get_collections
    user_api_call(:collections).map do |collection|
      photos = collection_api_call(collection, :photos).map do |photo|
        PhotoData.new(photo.id, photo.urls.thumb)
      end

      CollectionData.new(collection.id,
                         collection.title,
                         collection.total_photos,
                         photos)
    end
  end
end

