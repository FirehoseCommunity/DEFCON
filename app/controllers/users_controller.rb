class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :only_self_and_admin, except: :show

  def show
    @badge = Badge.new
    # will allow you to view anyone's profile for now
    # some things are currently hidden in the view
    # maybe add a separate/modified view for a public profile and restrict the dashboard?
  end

  def edit
    # only lets a user update their own profile (unless admin)
  end

  def update
    # only lets a user update their own profile (unless admin)
    if selected_user.update_attributes(user_params)
      redirect_to user_path(selected_user)
    else
      flash[:alert]=selected_user.errors.messages.first.last.to_sentence
      redirect_to edit_user_path(selected_user)
    end
  end

  private
    helper_method :selected_user
    def selected_user
      @selected_user ||= User.find_by_id(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :post_notification, :comment_notification, :github_handle)
    end

    def only_self_and_admin
      unless current_user == selected_user || current_user.admin?
        flash[:alert]= "Can only edit your own profile!"
        redirect_to root_path
      end
    end
end
