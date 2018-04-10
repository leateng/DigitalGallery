class ClientsController < ApplicationController
  def index
    @clients = User.clients
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