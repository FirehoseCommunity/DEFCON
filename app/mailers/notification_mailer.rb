class NotificationMailer < ActionMailer::Base
  default from: "noreply@firehose-defcon.com"

  def send_notification(new_post_id, recipient_id)
    @new_post = Post.find(new_post_id)
    @recipient = User.find(recipient_id)
    mail(to: @recipient.email,
         subject: "A new post from #{@new_post.user.name} has been added to the Defcon Student Group")
  end
end
