class User < ActiveRecord::Base
  include Gravtastic
  gravtastic
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         :omniauth_providers => [:github]


  has_many :posts, dependent: :destroy 
  has_many :comments 
  validates :name, presence: { :message => "Name is required!" }
  scope :users_to_notify, -> { where(:post_notification => true)  }
  acts_as_voter # Users can upvote posts.

  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.id).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def can_edit?(p)
      return false if p.blank?

      p.user_id == self.id 
  end

  def promote(user)
    self.admin ? user.update(:admin => true) : false
  end

  def self.search(term)
    # could use ILIKE since we're using postgres to drop downcase
    where('LOWER(email) LIKE :term OR LOWER(name) LIKE :term', term: "%#{term.downcase}%")
  end

  # Check if a user voted on a post. Cf. /views/posts/index.html.haml line 63.
  def upvoted?(post)
    voted_up_on? post
  end
end 
