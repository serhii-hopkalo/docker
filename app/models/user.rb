class User < ApplicationRecord
  validates :name, :email, presence: true, length: { minimum: 5 }
  validates :email, uniqueness: true, length: { minimum: 5 }
end
