json.array!(@songs) do |song|
  json.extract! song, :id, :name, :description, :youtube_url, :mp3_url, :picture_url
  json.url song_url(song, format: :json)
end
