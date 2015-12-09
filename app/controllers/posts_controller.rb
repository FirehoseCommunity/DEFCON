class PostsController < ApplicationController
  # before_action :authenticate_user!

  def index
    @posts = Post.all
    @post = Post.new
  end

  def create
    @post = @user.post.create(post_params)
    if @post.valid?
      redirect_to posts_path
    else
      render :new, :status => :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end

end
