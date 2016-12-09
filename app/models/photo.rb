class Photo < ActiveRecord::Base
  has_many :photo_queues
  has_many :users, through: :photo_queues

  validates :unsplash_id, uniqueness: true, presence: true
end
