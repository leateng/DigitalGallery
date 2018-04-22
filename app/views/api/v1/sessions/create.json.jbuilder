json.session do
  json.(@user, :id, :name, :email, :telephone, :role)
  json.token @user.authentication_token
end