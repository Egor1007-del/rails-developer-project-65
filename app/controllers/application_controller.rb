class ApplicationController < ActionController::Base
  helper_method :current_user, :signed_in?


  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError do
    redirect_to root_path, alert: t("pundit.not_authorized")
  end


  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def signed_in?
    current_user.present?
  end

  def authenticate_user!
    return if signed_in?

    redirect_to root_path, alert: t("auth.reqired")
  end
end
