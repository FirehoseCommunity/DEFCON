class Admin::UsersController < AdminController

  def index
    respond_to do |format|
      format.html { @users = User.all }
      format.json { @users = User.search(params[:term]) }
    end
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
