class CommentsController < ApplicationController
  before_action :authenticate_user!

def create
  @post = Post.find(params[:post_id])
  @post.comments.create(comment_params.merge(:user => current_user))
  redirect_to post_path(@post)
end

def destroy
  @post = comment.post
  comment.destroy 
  redirect_to post_path(@post)
end

private

def require_comment
  render_not_found unless @comment
end

def comment
  @comment ||= Comment.find_by_id(params[:id])
end

def require_comment_destroyable
    render_not_found(:forbidden) unless comment.controlled_by?(current_user)
end

  def comment_params
    params.require(:comment).permit(:message)
  end
end



