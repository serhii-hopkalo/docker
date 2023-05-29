class Transact < ApplicationRecord

  validates :status, presence: true

  enum status: { authorize: 0, charge: 1, refund: 2, error: 3 }

  belongs_to :merchant, foreign_key: :user_id

end
