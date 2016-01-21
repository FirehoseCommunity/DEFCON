class User < ActiveRecord::Base
  include Gravtastic
  gravtastic
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :posts
  has_many :comments 
  validates :name, presence: { :message => "Name is required!" }
  scope :users_to_notify, -> { where(:post_notification => true)  }

  def can_edit?(p)
      return false if p.blank?
      p.user_id == self.id 
  end

  def promote(user)
    self.admin? ? user.update(:admin => true) : false
  end

  def self.search(term)
    # could use ILIKE since we're using postgres to drop downcase
    where('LOWER(email) LIKE :term OR LOWER(name) LIKE :term', term: "%#{term.downcase}%")
  end
end 
