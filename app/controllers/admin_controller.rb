class AdminController < ApplicationController
  before_action :verify_admin

  private

  def verify_admin
    unless current_user && current_user.admin?
      redirect_to root_path, flash: {alert: "Unauthorized"} 
    end
  end
end
