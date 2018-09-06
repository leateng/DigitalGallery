class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user!, only: [:show, :update, :images, :ar_images]

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(update_params)
  end

  def images
    @images = current_user.images
  end

  def ar_images
    @images = current_user.images.select{|i| i.has_video?}
  end

  private

  def update_params
    params.require(:user).permit(:name, :telephone)
  end
end