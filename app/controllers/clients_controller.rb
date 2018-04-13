class ClientsController < ApplicationController
  # todo: 权限系统完成后要改造成只 User.clients
  def index
    s_text = params[:search]
    if s_text.blank?
      @users = User.all
    else
      @users = User.where("name=? or email=? or telephone=?", s_text, s_text, s_text)
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
  end
end