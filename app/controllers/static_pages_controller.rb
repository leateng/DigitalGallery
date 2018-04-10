class StaticPagesController < ApplicationController
  skip_before_action :check_login, only: [:home, :help, :about, :contact]
  def home
  end

  def help
  end

  def about
  end

  def contact
  end
end
