class User < ApplicationRecord
  validates :name, :email, presence: true, length: { minimum: 5 }
  validates :email, uniqueness: true, length: { minimum: 5 }

  def admin?
    self.type == 'Admin'
  end

  def merchant?
    self.type == 'Merchant'
  end
end
