class CreatePhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :photos do |t|
      t.string :unsplash_id, index: true
      t.string :thumb_url

      t.timestamps
    end
  end
end
