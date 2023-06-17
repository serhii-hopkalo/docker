class MerchantTotalAmountService
  include Interactor

  def call
    sum = Charged.where(user_id: context.merchant_id).sum(:amount)

    Merchant.find(context.merchant_id).update!(total_transaction_sum: sum)
  end
end
