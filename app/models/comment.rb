class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  after_create :send_post_owner_notification, :send_post_interactor_notification
  
  def controlled_by?(user)
    self.user == user
  end

  def send_post_owner_notification
    # don't notify the post owner if they comment on their own post
    if self.post.user.comment_notification? && self.user != self.post.user
      CommentNotificationMailer.send_notification(self.post.id, self.id, self.post.user.id).deliver_later
    end
  end

  def send_post_interactor_notification
    # also excludes post creator so they don't get two notifications
    @recipients = User.joins(:comments).where(comments: {post_id: self.post.id}).where("post_interaction_notification = ? AND email != ? AND email != ?", true, self.user.email, self.post.user.email)
    unless @recipients.empty?
      @recipients.each do |recipient|
        CommentNotificationMailer.send_notification(self.post.id, self.id, recipient.id).deliver_later
      end
    end
  end
end
