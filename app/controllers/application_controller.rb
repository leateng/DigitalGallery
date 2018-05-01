class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :check_login

  rescue_from CanCan::AccessDenied do
    flash[:error] = "对不起， 您没有权限访问此页面！"
    redirect_to root_path
  end


  def check_login
    if current_user.blank?
      flash[:info] = "请先登录"
      redirect_to login_path
    end
  end
end
