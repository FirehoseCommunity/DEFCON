class PostsController < ApplicationController
  before_filter :authenticate_user!

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
    @comment = Comment.new
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

  def upvote
    @post = Post.find(params[:id])
    @post.upvote_by current_user
    redirect_to posts_path
  end

  def unvote
    @post = Post.find(params[:id])
    @post.unvote_by current_user
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end

end
