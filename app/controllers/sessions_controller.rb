class SessionsController < ApplicationController
  skip_before_action :check_login, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by( telephone: params[:session][:name] )
    if user && user.authenticate(params[:session][:password])
      log_in user

      case user.role
      when "user"
        redirect_to user
      when "operator"
        redirect_to clients_path
      when "admin"
        redirect_to root_path
      else
        redirect_to root_path
      end
    else
      flash.now[:error] = "错误的用户名或密码"
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
