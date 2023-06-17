class Charged < Transact
  belongs_to :authorized, foreign_key: :transact_id, dependent: :destroy

  has_one :refunded, dependent: :destroy, foreign_key: :transact_id

  after_create :process_total_transactions_amount

  private

  def process_total_transactions_amount
    ProcessMerchantTotalTransactionsAmount.perform_later(merchant_id: self.user_id)
  end
end
