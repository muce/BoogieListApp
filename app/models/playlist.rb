class Playlist < ActiveRecord::Base
  belongs_to :users
  has_many :playlist_songs
  has_many :songs, through: :playlist_songs
end
