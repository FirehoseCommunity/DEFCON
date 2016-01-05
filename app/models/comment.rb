class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  
  def controlled_by?(user)
    self.user == user
  end 
end
