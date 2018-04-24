json.(@user, :id, :name, :email, :telephone, :role)
json.token @user.authentication_token
json.avatar_url @user.gravatar.url.to_s