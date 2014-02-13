class Post < ActiveRecord::Base
  has_many :playlist_posts
  has_many :playlists, through: :playlist_posts
  
  def rip
    i = link_url.to_s
    d = Rails.root.join('public', 'audio').to_s
    f = "/"+facebook_id+".mp3"
    o = d+f
    `youtube-dl -o #{o} -x --audio-format mp3 #{i}`
  end
  
end
