class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def render_not_found(status = :not_found)
    render :text => "Error: #{status.to_s.titleize}",
      :status => status
  end
end
