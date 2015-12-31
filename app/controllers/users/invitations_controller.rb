class Users::InvitationsController < Devise::InvitationsController
  before_action :check_if_admin

  private

  def check_if_admin
    if !current_user.admin
      render :text => 'Unauthorized', :status => :unauthorized
    end
  end

end
