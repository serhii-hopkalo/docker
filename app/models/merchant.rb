class Merchant < User
  enum status: { active: 0, inactive: 1 }

  validates :total_transaction_sum, numericality: { greater_than_or_equal_to: 0 }

  has_many :transacts, foreign_key: :user_id
  has_many :authorizeds, foreign_key: :user_id
end
