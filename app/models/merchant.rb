class Merchant < User
  enum status: { active: 0, inactive: 1 }

  validates :total_transaction_sum, numericality: { greater_than_or_equal_to: 0 }
end
