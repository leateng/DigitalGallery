class UsersController < ApplicationController
  load_and_authorize_resource
  skip_before_action :check_login, only: [:new, :create, :download_app]

  def index
    if current_user.admin?
      users = User.all
    else
      users = User.clients
    end
    @users = filter_users(users).page(params[:page]).per(15)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new(role: "client")
  end

  def create
    set_password_for_client if params[:build_client].present?
    @user = User.new(user_params)
    @user.role = "client"
    if @user.save
      if params[:build_client].present?
        flash[:success] = "创建客户#{@user.name}成功"
      else
        log_in @user
        flash[:success] = "欢迎登陆魔扫应用!"
      end

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
    attrs = {name: params[:user][:name],
             email: params[:user][:email],
             telephone: params[:user][:telephone],
             gravatar: params[:user][:gravatar],
             update_profile: true}
    attrs[:role] = params[:user][:role] if current_user.admin?

    if @user.update(attrs)
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

    if current_user.admin?
      redirect_to users_path
    else
      redirect_to clients_path
    end

    #redirect_back fallback_location: users_path
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

    if @user.update_attribute(:app, params[:app])
      render json: @user.to_json, status: 200
    else
      render json: @user.errors, status: 300
    end
  end

  def download_app
    @user = User.find(params[:id])


    if @user.nil? || @user.app.blank?
      render  "errors/404", status: 404
    else
      response.headers['Content-Length'] = @user.app.size.to_s
      send_file @user.app.path, filename: "prettybaby.apk", content_type: "application/vnd.android.package-archive", x_sendfile: true
    end
  end

  require 'tempfile'
  require 'zip'
  def assets_bundle
    @user = User.find(params[:id])
    Zip.default_compression = Zlib::BEST_SPEED

    f = Tempfile.new
    Zip::File.open(f.path, Zip::File::CREATE) do |zipfile|
      @user.images.each_with_index do |image, index|
        if image.video_id.present?
          zipfile.add("#{index}.jpg", image.content.path)
          zipfile.add("#{index}.mp4", image.relate_video.content.path)
        end
      end
      zipfile.get_output_stream("targets.json") { |f| f.write @user.targets_json.to_json }
    end

    send_file f.path, filename: "#{@user.name}-image-pack.zip", type: "application/zip"
  end

  private

  def user_params
    params.require(:user).permit(:name,
                                 :email,
                                 :password,
                                 :password_confirmation,
                                 :gravatar,
                                 :telephone,
                                 :order_id)
  end

  # 为operator创建的新客户账号设定默认密码
  def set_password_for_client
    random_password = SecureRandom.hex(3)
    params[:user][:password] = random_password
    params[:user][:password_confirmation] = random_password
  end

  # 搜索用户
  def filter_users(users)
    s_text = params[:search]
    users = users.where("name like ? or order_id like ?", s_text+'%', s_text+'%') if s_text.present?
    if params[:app].present?
      if params[:app] == "on"
        users = users.where("app is not NULL")
      else
        users = users.where("app is NULL")
      end
    end
    users
  end
end