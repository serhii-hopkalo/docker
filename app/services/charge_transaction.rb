class ChargeTransaction < ApplicationService
  def call
    super

    check_authorized!

    if charged.save
      ProcessMerchantTotalTransactionsAmount.perform_later(merchant_id: context.merchant_id)

      context.transaction = charged
    else
      context.fail!(errors: charged.errors.full_messages)
    end
  end

  private

  def check_authorized!
    authorized = Authorized.find_by(id: context.referenced_transaction_uuid)

    if authorized.blank?
      context.fail!(
        errors: "Could not find Authorized transaction with given uuid #{context.referenced_transaction_uuid}"
      )
    end

    unless authorized.approved?
      context.fail!(errors: ["Referenced transaction does not has approved status"])
    end
  end

  def charged
    return @charged if defined? @charged

    @charged =
      Charged.new(
        merchant: context.merchant,
        amount: context.amount,
        customer_email: context.customer_email,
        customer_phone: context.customer_phone,
        status: :approved,
        transact_id: context.referenced_transaction_uuid
      )
  end
end
