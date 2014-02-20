class Post < ActiveRecord::Base
  has_many :playlist_posts
  has_many :playlists, through: :playlist_posts
  
end
