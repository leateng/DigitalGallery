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

  def show
    @attachment = Attachment.find(params[:id])

    render layout: false
  end

  def edit
  end

  def update
  end

  def destroy
    @user = User.find(params[:user_id])
    @attachment = Attachment.find(params[:id])
    if @attachment.destroy
      flash['success'] = "#{@attachment.content.file.filename} 删除成功"
    else
      flash['error'] = "#{@attachment.content.file.filename} 删除失败"
    end

    redirect_to user_attachments_path(@user)
  end

  def relate_video
    image = Attachment.find(params["image_id"])
    video = Attachment.find(params["video_id"])

    if image.blank? || video.blank?
      render json: {status: 404, message: "record not found"}
    else
      image.video_id = video.id
      if image.save
        render json: {status: 200, message: "success"}
      else
        render json: {status: 500, message: "error"}
      end
    end
  end
end
