class AppMailer < ActionMailer::Base
 
  default from: 'noreply@firehose-defcon.com'
 
  def welcome_email(user)
    @user = user
    mail(to: @user.email, 
         subject: "Welcome!")
  end
end