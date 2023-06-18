class Charged < Transact
  belongs_to :authorized, foreign_key: :transact_id, dependent: :destroy

  has_one :refunded, dependent: :destroy, foreign_key: :transact_id
end
