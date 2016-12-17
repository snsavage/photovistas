class AddTimeFieldsToPhotoQueues < ActiveRecord::Migration[5.0]
  def change
    add_column :photo_queues, :last_viewed, :date
  end
end
