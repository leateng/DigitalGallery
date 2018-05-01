class Api::V1::BaseController < ActionController::Base
  # disable the CSRF token
  protect_from_forgery with: :null_session

  # disable cookies (no set-cookies header in response)
  before_action :destroy_session

  # disable the CSRF token
  skip_before_action :verify_authenticity_token

  attr_accessor :current_user

  def destroy_session
    request.session_options[:skip] = true
  end

  def api_error(status)
    head status
  end

  def unauthenticated!
    api_error(401)
  end

  def authenticate_user!
    # header format
    # Authorization:Token token={token_str}, telephone=12345678903

    token, options = ActionController::HttpAuthentication::Token.token_and_options(request)
    user_telephone = options.blank? ? nil : options[:telephone]
    user = user_telephone && User.find_by(telephone: user_telephone)

    if user && ActiveSupport::SecurityUtils.secure_compare(user.authentication_token, token)
      self.current_user = user
    else
      return unauthenticated!
    end
  end
end