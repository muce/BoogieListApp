class PlaylistPost < ActiveRecord::Base
  belongs_to :playlist
  belongs_to :post
end
