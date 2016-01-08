class Admin::UsersController < AdminController

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(user_params)
    redirect_to user_path(@user), flash: {notice: "Updated"}
  end

  private

  def user_params
    params.require(:user).permit(:email, :admin)
  end

end
