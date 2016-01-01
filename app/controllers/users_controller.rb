class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    # will just allow you to see your own dashboard for now
    # maybe add a separate/modified view for a public profile?
    @user = current_user
  end

  def edit
    # only lets a user edit their own profile
    # should add admin capability in the future
    @user = current_user
    @notification_options = [["New Posts and Comments", "Posts and Comments"], ["New Posts", "Posts"], ["None", "None"]]
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      redirect_to user_path(@user)
    else
      flash[:alert]=@user.errors.messages.first.last.to_sentence
      redirect_to edit_user_path(@user)
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :notification_type)
    end
end
