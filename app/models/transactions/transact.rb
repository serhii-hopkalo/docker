class Transact < ApplicationRecord

  validates :status, presence: true

  enum status: { approved: 0, reversed: 1, refunded: 2, error: 3 }

  belongs_to :merchant, foreign_key: :user_id

end
