class AddColumnsToTable < ActiveRecord::Migration
  def change
    add_column :posts, :artist, :string
    add_column :posts, :title, :string
  end
end
