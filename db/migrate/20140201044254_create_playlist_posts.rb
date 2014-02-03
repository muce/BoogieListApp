class CreatePlaylistPosts < ActiveRecord::Migration
  def change
    create_table :playlist_posts do |t|
      t.integer :playlist_id
      t.integer :post_id

      t.timestamps
    end
  end
end
