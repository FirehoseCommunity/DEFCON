class AppMailer < ActionMailer::Base
 
  default from: 'noreply@firehose-defcon.com'
 
  def welcome_email
    mail(to: 'matt@thefirehoseproject.com', 
         subject: "Welcome!")
  end
end