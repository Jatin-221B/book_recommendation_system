class ApplicationController < ActionController::Base
  include Pundit::Authorization
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
  # remove after adding devise later
  # def current_user
  #   @current_user ||= User.first
  # end
  # helper_method :current_user

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  layout :layout_by_resource

  helper_method :admin?

  def admin?
    current_user&.admin?
  end

  def require_admin!
    redirect_to root_path, alert: "Access denied." unless admin?
  end
private

def layout_by_resource
  if devise_controller?
    "devise"
  else
    "application"
  end
end

def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
      devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
    end
end
