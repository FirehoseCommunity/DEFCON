class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #before_filter :configure_sanitized_params, if: :devise_controller?

  #def configure_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:github_handle)}
  #end


  def render_not_found(status = :not_found)
    render :text => "Error: #{status.to_s.titleize}",
      :status => status
  end
end
