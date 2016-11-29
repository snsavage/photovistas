class User < ActiveRecord::Base
  has_secure_password

  validates :username, :email, :password, presence: true
  validates :username, :email, uniqueness: true
  validates :username, length: { in: 2..25 }
  validates :password, length: { in: 8..48 }
end
