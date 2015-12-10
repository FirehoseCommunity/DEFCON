class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save :check_if_first_user

  def check_if_first_user
    User.any? ? self.admin = false : self.admin = true
  end

end
