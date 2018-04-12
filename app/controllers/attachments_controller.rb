class AttachmentsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
  end

  def new
  end

  def create
    @user = User.find(params[:user_id])
    @attachment = @user.attachments.build(content: params[:content], creator_id: current_user.id)

    if @attachment.save
      render json: @attachment.to_json, status: 200
    else
      render json: @attachment.errors, status: 300
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @user = User.find(params[:user_id])
    @attachment = Attachment.find(params[:id])
    @attachment.destroy

    redirect_to gallery_user_url(@user)
  end
end
