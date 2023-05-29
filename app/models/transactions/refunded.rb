class Refunded < Transact
  belongs_to :charged, foreign_key: :transact_id, dependent: :destroy
end
