class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :facebook_id
      t.string :name
      t.string :description
      t.string :link_url
      t.string :source_url
      t.string :message
      t.integer :likes
      t.integer :comments

      t.timestamps
    end
  end
end
