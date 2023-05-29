class Reversal < Transact
  belongs_to :merchant, foreign_key: :user_id

  belongs_to :authorized, foreign_key: :transact_id

end
