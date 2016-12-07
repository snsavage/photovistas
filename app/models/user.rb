class User < ActiveRecord::Base
  has_secure_password

  has_many :photo_queues
  has_many:photos, through: :photo_queues

  validates :username, :email, presence: true
  validates :username, :email, uniqueness: true
  validates :username, format: { with: /\A[a-zA-Z0-9]+\z/,
                                 message: "only allows letters and numbers" }
  validates :username, length: { in: 2..25 }
  validates :password, length: { in: 8..48 }, allow_nil: true

  serialize :unsplash_token

  def add_photos_to_queue(photos_to_add)
    photos_to_add.map do |photo|
      photos.find_or_create_by(unsplash_id: photo[:unsplash_id]) do |x|
        x.thumb_url = photo[:thumb_url]
      end
    end
  end

  # photos.create(photos_to_add)

  # dup_photos = photos.collect do |photo|
  #   photo.unsplash_id if photo.invalid?
  # end

  # if !dup_photos.empty?
  #   photos_to_associate = Photo.where(unsplash_id: dup_photos)
  #   photos << photos_to_associate
  # end
end
