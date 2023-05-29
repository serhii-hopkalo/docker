class Authorized < Transact
  belongs_to :merchant, foreign_key: :user_id

  has_one :charged, dependent: :destroy, foreign_key: :transact_id
  has_one :reversal, dependent: :destroy, foreign_key: :transact_id

  validates :amount,
    presence: true,
    numericality: { only_integer: true, greater_than: 0 }

  validates :customer_email, presence: true, length: { minimum: 5 }
  validates :customer_phone, presence: true, length: { minimum: 5 }
end
