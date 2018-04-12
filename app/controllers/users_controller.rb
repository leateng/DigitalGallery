class UsersController < ApplicationController
  skip_before_action :check_login, only: [:new, :create]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the sample App!"
      redirect_to @user
    else
      render "new"
    end
  end

  def gallery
    @user = User.find(params[:id])
  end

  def clients
    @users = User.all
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                :password_confirmation)
  end
end
