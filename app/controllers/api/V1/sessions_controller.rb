class Api::V1::SessionsController <  Api::V1::BaseController
  def create
    @user = User.find_by(telephone: create_params[:telephone].downcase)

    if @user && @user.authenticate(create_params[:password])
      self.current_user = @user
    else
      if @user.blank?
        api_error 404
      else
        api_error 401
      end
    end
  end

  private

  def create_params
    params.require(:user).permit(:telephone, :password)
  end
end
