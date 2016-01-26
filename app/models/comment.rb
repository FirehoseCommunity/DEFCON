class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  after_create :send_post_owner_notification, :send_post_interactor_notification
  
  def controlled_by?(user)
    self.user == user
  end

  def send_post_owner_notification
  end

  def send_post_interactor_notification
    @recipients = User.where("post_interaction_notification = ? AND email != ?", true, self.post.user.email)
    unless @recipients.empty?
      @recipients.each do |recipient|
        NotificationMailer.send_notification(self.id, recipient.id).deliver_later
      end
    end
  end
end
