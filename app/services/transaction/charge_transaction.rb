module Transaction
  class ChargeTransaction < BaseService
    def call
      super

      check_authorized!

      if charged.save
        ProcessMerchantTotalTransactionsAmount.perform_later(merchant_id: context.merchant.id)

        context.transaction = charged
      else
        context.fail!(errors: charged.errors.full_messages)
      end
    end

    private

    def check_authorized!
      authorized = Authorized.find_by(id: context.transaction[:referenced_transaction_uuid])

      if authorized.blank?
        context.fail!(
          errors: "Could not find Authorized transaction with given uuid #{context.transaction[:referenced_transaction_uuid]}"
        )
      end

      unless authorized.approved?
        context.fail!(errors: "Referenced transaction does not has approved status")
      end
    end

    def charged
      return @charged if defined? @charged

      @charged =
        Charged.new(
          merchant: context.merchant,
          amount: context.transaction[:amount],
          customer_email: context.transaction[:customer_email],
          customer_phone: context.transaction[:customer_phone],
          transact_id: context.transaction[:referenced_transaction_uuid],
          status: :approved,
        )
    end
  end
end
