class ClientsController < ApplicationController
  # todo: 权限系统完成后要改造成只 User.clients
  # todo: 对附件数量可以添加字段做counter_cache
  def index
    s_text = params[:search]
    if s_text.blank?
      @users = User.clients.includes(:attachments).all.page(params[:page]).per(15)
    else
      s_text.strip!
      @users = User.clients.includes(:attachments).where("name=? or email=? or telephone=?", s_text, s_text, s_text).page(params[:page])
    end
  end

  def show
  end

  def new
    @client = User.new(role: "user")
  end

  def create
    @client = User.new(client_params)
    @client.password = @client.telephone + "@123"
    @client.password_confirmation = @client.telephone + "@123"
    @client.role = "user"

    if @client.save
      flash[:success] = "创建客户#{@client.name}成功"
      redirect_to clients_path
    else
      render "new"
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @client = User.find(params[:id])

    if @client.destroy
      flash[:success] = "用户#{@client.name}已成功删除"
    else
      flash[:error] = "用户#{@client.name}删除失败！"
    end

    redirect_back fallback_location: clients_path
  end

  def client_params
    params.require(:user).permit(:name,
                                 :email,
                                 :telephone)
  end
end