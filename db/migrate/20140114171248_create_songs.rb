class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :name
      t.string :description
      t.string :youtube_url
      t.string :mp3_url
      t.string :picture_url

      t.timestamps
    end
  end
end
