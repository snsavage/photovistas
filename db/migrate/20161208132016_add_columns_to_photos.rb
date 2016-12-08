class AddColumnsToPhotos < ActiveRecord::Migration[5.0]
  def change
    change_table :photos do |t|
      t.integer :width
      t.integer :height
      t.string :photographer_name
      t.string :photographer_link
      t.string :raw_url
      t.string :full_url
      t.string :regular_url
      t.string :small_url
      t.string :link
    end
  end
end
