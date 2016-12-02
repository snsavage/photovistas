class AddUnsplashTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :unsplash_token, :text
  end
end
