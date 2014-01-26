json.array!(@posts) do |post|
  json.extract! post, :id, :facebook_id, :name, :description, :link_url, :source_url, :message, :likes, :comments
  json.url post_url(post, format: :json)
end
