json.array!(@polls) do |poll|
  json.extract! poll, :id, :title, :content, :options, :permissions
  json.url poll_url(poll, format: :json)
end
