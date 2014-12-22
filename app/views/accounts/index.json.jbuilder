json.array!(@accounts) do |account|
  json.extract! account, :id, :name, :description, :balance, :user_dn
  json.url account_url(account, format: :json)
end
