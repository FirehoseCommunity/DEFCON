class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  after_create :send_post_owner_notification, :send_post_interactor_notification
  
  def controlled_by?(user)
    self.user == user
  end

  def send_post_owner_notification
    if self.post.user.comment_notification?
      CommentNotificationMailer.send_notification(self.post.id, self.id, self.post.user.id).deliver_later
    end
  end

  def send_post_interactor_notification
    # excludes post creator so they don't get two notifications
    @recipients = User.where("post_interaction_notification = ? AND email != ?", true, self.post.user.email)
    unless @recipients.empty?
      @recipients.each do |recipient|
        CommentNotificationMailer.send_notification(self.post.id, self.id, recipient.id).deliver_later
      end
    end
  end
end
