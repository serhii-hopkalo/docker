class ProcessMerchantTotalTransactionsAmount < ApplicationJob
  queue_as :default

  def perform(merchant_id)
    MerchantTotalAmountService.call(merchant_id: merchant_id)
  end
end
