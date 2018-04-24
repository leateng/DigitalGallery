class UsersController < ApplicationController
  skip_before_action :check_login, only: [:new, :create]

  def index
    s_text = params[:search]
    if !s_text.blank?
      @users = User.where("name=? or email=? or telephone=?", s_text, s_text, s_text)
    else
      @users = User.all
    end

    @users = @users.page(params[:page]).per(15)
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

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update({name: params[:user][:name],
                     email: params[:user][:email],
                     telephone: params[:user][:telephone],
                     gravatar: params[:user][:gravatar],
                     role: params[:user][:role],
                     update_profile: true})

      flash[:success] = "用户#{@user.name}信息已成功更新！"
      redirect_to user_path(@user)
    else
      flash.now[:error] = "用户#{@user.name}信息已更新失败！"
      render "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])

    if @user.destroy
      flash[:success] = "用户#{@user.name}已成功删除"
    else
      flash[:error] = "用户#{@user.name}删除失败！"
    end

    redirect_back fallback_location: users_path
  end

  def edit_password
    @user = User.find(params[:id])
  end

  def update_password
    @user = User.find(params[:id])
    if @user && @user.authenticate(params[:old_password])
      @user.password = params[:password]
      @user.password_confirmation = params[:password_confirmation]

      if @user.save
        flash[:success] = "更新 #{@user.name} 密码成功！"
        redirect_to users_path
        return
      else
        flash.now[:error] = "更新 #{@user.name} 密码失败！"
        render "edit_password"
      end
    else
      flash.now[:error] = "旧的密码输入错误！"
      render "edit_password"
    end
  end

  def upload_app
    @user = User.find(params[:id])
    #binding.pry
    if @user.update_attribute(:app, params[:app])
      render json: @user.to_json, status: 200
    else
      render json: @user.errors, status: 300
    end
  end

  private

  def user_params
    params.require(:user).permit(:name,
                                 :email,
                                 :password,
                                 :password_confirmation,
                                 :gravatar,
                                 :telephone)
  end
end
