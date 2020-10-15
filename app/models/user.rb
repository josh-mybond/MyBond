class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  ROLE = {
    user:    0,
    admin: 100
  }

  def self.create_user!(params)
    User.create(params)
  end

  def user?
    self.role == ROLE[:user]
  end

  def admin?
    self.role == ROLE[:admin]
  end

end
