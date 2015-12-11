class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable


  has_many :posts
  before_save :check_if_first_user

  def check_if_first_user
    self.admin = !User.any?
  end

end
