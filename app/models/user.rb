class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :validatable

  validates :name, :email, presence: true, length: { minimum: 5 }
  validates :email, uniqueness: true, length: { minimum: 5 }

  def admin?
    self.type == 'AdminUser'
  end

  def merchant?
    self.type == 'Merchant'
  end
end
