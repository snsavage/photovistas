class AddPhotosCountColumnToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.integer :photos_count
    end
  end
end
