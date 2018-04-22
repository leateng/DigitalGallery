json.user do
  json.(@user, :id, :email, :name,  :telephone, :role, :created_at, :updated_at)
end