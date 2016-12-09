class PhotoQueue < ActiveRecord::Base
  belongs_to :user, counter_cache: :photos_count
  belongs_to :photo

  validates_uniqueness_of :photo_id, scope: :user_id
end
