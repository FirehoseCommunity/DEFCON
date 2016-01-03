class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :only_self_and_admin, except: :show

  def show
    # will allow you to view anyone's profile for now 
    # some things are currently hidden in the view
    # maybe add a separate/modified view for a public profile and restrict the dashboard?
    @user = User.find(params[:id])
  end

  def edit
    # only lets a user update their own profile (unless admin)
    @user = User.find(params[:id])
  end

  def update
    # only lets a user update their own profile (unless admin)
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to user_path(@user)
    else
      flash[:alert]=@user.errors.messages.first.last.to_sentence
      redirect_to edit_user_path(@user)
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :post_notification, :comment_notification)
    end

    def only_self_and_admin
      unless current_user == User.find(params[:id]) || current_user.admin?
        flash[:alert]= "Can only edit your own profile!"
        redirect_to root_path
      end
    end
end
