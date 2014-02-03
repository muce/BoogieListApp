json.array!(@playlist_posts) do |playlist_post|
  json.extract! playlist_post, :id, :playlist_id, :post_id
  json.url playlist_post_url(playlist_post, format: :json)
end
