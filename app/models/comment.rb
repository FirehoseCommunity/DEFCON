class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  has_many :votes, :as => :votable
  
  def controlled_by?(user)
    self.user == user
  end 
end
