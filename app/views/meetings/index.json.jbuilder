json.array!(@meetings) do |meeting|
  json.extract! meeting, :id, :name, :description, :location, :start, :finish, :required, :verified
  json.url meeting_url(meeting, format: :json)
end
