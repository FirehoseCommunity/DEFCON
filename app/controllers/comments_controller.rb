class CommentsController < ApplicationController
  before_action :authenticate_user!
def create
  @post = Post.find(params[:post_id])
  @post.comments.create(comment_params.merge(:user => current_user))
  redirect_to post_path(@post)
end

private

  def comment_params
    params.require(:comment).permit(:message)
  end
end



