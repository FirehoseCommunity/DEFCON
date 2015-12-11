class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.all
    @post = Post.new
  end

  def create
    @post = current_user.posts.create(post_params)
    if @post.valid?
      redirect_to posts_path
    else
      render :new, :status => :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.update_attributes(post_params)
    if @post.valid?
      redirect_to posts_path
    else
      render :edit, :status => :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end

end
