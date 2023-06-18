class DeleteMerchantService
  include Interactor

  def call
    if Transact.where(user_id: context.merchant_id).count > 0
      context.fail!(error: "Merchant #{context.merchant_id} still has related payment transactions")
    else
      Merchant.find(context.merchant_id).delete
    end
  end
end
