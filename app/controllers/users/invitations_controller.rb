class Users::InvitationsController < Devise::InvitationsController
  private

  def invite_resource
    if user.admin.false
      render :text => 'Unauthorized', :status => :unauthorized
    end
  end

end
