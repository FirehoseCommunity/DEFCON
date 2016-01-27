class CommentNotificationMailer < ActionMailer::Base
  default from: "noreply@firehose-defcon.com"

  def send_notification(post_id, comment_id, recipient_id)
    @comment_post = Post.find(post_id)
    @new_comment = Comment.find(comment_id)
    @recipient = User.find(recipient_id)
    mail(to: @recipient.email,
         subject: "A new comment from #{@new_comment.user.name} has been added to the post #{@comment_post.title} in the Defcon Student Group")
  end
end
