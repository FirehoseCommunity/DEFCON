class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  
  def comment_on_post
    self.user_id
  end 
end
