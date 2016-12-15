class RemoveIndexColumnFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :index, :string
  end
end
