class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "You are not authorized to take this action. Go away or I shall taunt you a second time"
    redirect_to_home_path
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    flash[:error] = "Seek and you shall find... but not this time"
    redirect_to_home_path
  end
  private

  def current_user
    @current_user ||= Officer.find(session[:officer_id]) if session[:officer_id]
  end

  def logged_in?
    current_user.present?
  end

  def check_login
    redirect_to login_path, alert: "You need to log in to view this page." unless logged_in?
  end
end