json.array!(@news) do |news|
  json.extract! news, :id, :title, :content, :user_dn
  json.url news_url(news, format: :json)
end
