class NotificationMailer < ActionMailer::Base
  default to: Proc.new { User.where(post_notification: true).pluck(:email) },
          from: "noreply@firehose-defcon.com"

  def send_notification(user)
    @user = user
    mail(subject: "A new post from #{@user.email} has been added to the Defcon Student Group")
  end
end
