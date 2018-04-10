class AttachmentsController < ApplicationController
  def index
  end

  def new
  end

  def create
    @user = User.find(params[:user_id])
    @attachment = @user.attachments.build(content: params[:content])

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
  end
end
