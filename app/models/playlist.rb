class Playlist < ActiveRecord::Base
  belongs_to :users
  has_many :playlist_posts
  has_many :posts, through: :playlist_posts
end
