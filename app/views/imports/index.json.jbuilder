json.array!(@imports) do |import|
  json.extract! import, :id, :limit, :until, :paging_token
  json.url import_url(import, format: :json)
end
