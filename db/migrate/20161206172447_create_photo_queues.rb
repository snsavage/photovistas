class CreatePhotoQueues < ActiveRecord::Migration[5.0]
  def change
    create_table :photo_queues do |t|
      t.integer :user_id, index: true
      t.integer :photo_id, index: true

      t.timestamps
    end
  end
end
