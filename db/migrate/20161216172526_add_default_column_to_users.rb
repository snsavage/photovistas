class AddDefaultColumnToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :default, :boolean, index: :true, default: :false
  end
end
