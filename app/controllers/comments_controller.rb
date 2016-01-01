class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_current_post, :only => :create
  before_action :require_current_comment, :only => :destroy
  before_action :require_current_comment_destroyable, :only => :destroy
  before_action :require_current_comment_is_editable, :only => [:edit, :update, :destroy]


def create
  @post = Post.find_by_id(params[:post_id])
  render_not_found if @post.blank?
  @post.comments.create(comment_params.merge(:user => current_user))
  redirect_to post_path(@post)
end

def edit
  @comment = Comment.find(params[:id])
  if @comment.user != current_user
    return render :text => 'Not Allowed', :status => :forbidden
  end
end

def update
  @comment = Comment.find(params[:id])
  @comment.update_attributes(comment_params)
  if current_comment.valid?
    redirect_to post_path(@comment.post)
  else
    render :edit, :status => unprocessable_entity
  end
end

def destroy
  @post = current_comment.post
  current_comment.destroy 
  redirect_to post_path(@post)
end

private

def require_current_comment
    render_not_found unless current_comment
end

def current_comment
  @current_comment ||= Comment.find_by_id(params[:id])
end

def require_current_comment_destroyable
    render_not_found(:forbidden) unless current_comment.controlled_by?(current_user)
end

  def comment_params
    params.require(:comment).permit(:message)
  end
  
def require_current_post
    render_not_found unless current_post
end

def require_current_comment_is_editable
    unless current_user.can_edit?(current_comment)
      render_not_found(:unauthorized) 
    end
end
  
  helper_method :current_post
  def current_post
    @current_post ||= Post.find_by_id(params[:post_id])
  end
end



