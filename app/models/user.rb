class User < ActiveRecord::Base
  has_secure_password

  has_many :photo_queues
  has_many :photos, through: :photo_queues

  validates :username, :email, presence: true
  validates :username, :email, uniqueness: true
  validates :username, format: { with: /\A[a-zA-Z0-9]+\z/,
                                 message: "only allows letters and numbers" }
  validates :username, length: { in: 2..25 }
  validates :password, length: { in: 8..48 }, allow_nil: true

  serialize :unsplash_token

  def add_photos_to_queue(photos_to_add)
    photos.create(photos_to_add)

    if invalid?
      invalid_ids = photos.map {|x| x.unsplash_id if x.invalid?}.compact
      in_db = Photo.where(unsplash_id: invalid_ids)
      in_queue = photo_queues.where(photo_id: in_db).pluck(:photo_id)

      photos << in_db.select {|x| !in_queue.include?(x.id)}
    end

    # existing_photos = Photo.where(unsplash_id: unsplash_ids)
    # existing_queues = PhotoQueue.
    #   includes(:photos).
    #   where(photo_id: existing_photos)

    # photos_to_add.each do |photo|
    #   photos.find_or_create_by(unsplash_id: photo[:unsplash_id]) do |x|
    #     x.width = photo[:width]
    #     x.height = photo[:height]
    #     x.photographer_name = photo[:photographer_name]
    #     x.photographer_link = photo[:photographer_link]
    #     x.raw_url = photo[:raw_url]
    #     x.full_url = photo[:full_url]
    #     x.regular_url = photo[:regular_url]
    #     x.small_url = photo[:small_url]
    #     x.thumb_url = photo[:thumb_url]
    #     x.link = photo[:link]
    #   end
    # end
  end
end
