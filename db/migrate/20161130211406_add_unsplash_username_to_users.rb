class AddUnsplashUsernameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :unsplash_username, :string
  end
end
