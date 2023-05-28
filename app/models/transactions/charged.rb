class Charged < Transact
  belongs_to :authorized, foreign_key: :transact_id
end
