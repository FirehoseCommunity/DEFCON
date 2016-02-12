class PostsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_user_permissions, only: [:destroy]

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
    if current_post.blank?
      return render_not_found :not_found 
    else
      current_post.destroy 
      redirect_to posts_path
    end
  end

  private

  def check_user_permissions
    render_not_found :unauthorized unless current_user.admin || current_user.id == current_post.user_id
  end

  helper_method :current_post
  def current_post
    @current_post ||= Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end

end
