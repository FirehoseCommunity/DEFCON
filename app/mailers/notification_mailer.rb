class NotificationMailer < ActionMailer::Base
  default from: "noreply@firehose-defcon.com"

  def send_notification(new_post, recipient)
    @new_post = new_post
    @recipient = recipient
    mail(to: @recipient.email,
         subject: "A new post from #{@new_post.user.email} has been added to the Defcon Student Group")
  end
end
