class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :facebook_id
      t.string :name
      t.string :description
      t.string :artist
      t.string :title
      t.datetime :post_date
      t.string :link_url
      t.string :source_url
      t.string :picture_url
      t.string :mp3_url
      t.string :message
      t.integer :likes
      t.integer :comments
      t.string :contributor_name
      t.string :contributor_fb_id

      t.timestamps
    end
  end
end
