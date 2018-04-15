class ClientsController < ApplicationController
  # todo: 权限系统完成后要改造成只 User.clients
  # todo: 对附件数量可以添加字段做counter_cache
  def index
    s_text = params[:search]
    if s_text.blank?
      @users = User.includes(:attachments).all.page(params[:page]).per(15)
    else
      s_text.strip!
      @users = User.includes(:attachments).where("name=? or email=? or telephone=?", s_text, s_text, s_text).page(params[:page])
    end
  end

  def show
  end

  def new
    @client = User.new(role: "user")
  end

  def create
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
end