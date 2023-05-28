class Transact < ApplicationRecord

  validates :amount,
            presence: true,
            numericality: { only_integer: true, greater_than: 0 }

  validates :customer_email, presence: true, length: { minimum: 5 }
  validates :customer_phone, presence: true, length: { minimum: 5 }
  validates :status, presence: true

  enum status: { authorize: 0, charge: 1, refund: 2, error: 3 }

  belongs_to :merchant, foreign_key: :user_id


end
